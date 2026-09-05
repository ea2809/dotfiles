import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from karabiner_configurator import karabiner
from karabiner_configurator.config import load_config
from karabiner_configurator.helpers import resolve_variables


ROOT = Path(__file__).resolve().parents[1]


class SpaceFNTests(unittest.TestCase):
    def test_default_and_host_rules_compile_without_shadowing(self):
        default = json.loads((ROOT / "karabiner/config.default.json").read_text())
        default = resolve_variables(default, default)
        for name, config in (("default", default), ("host", load_config(str(ROOT / "karabiner")))):
            with self.subTest(config=name):
                rules = karabiner.main(config["spacefn_definitions"], config["normal_definitions"])["rules"]
                x_rules = [
                    (rule["description"], manipulator)
                    for rule in rules
                    for manipulator in rule["manipulators"]
                    if manipulator["from"].get("key_code") == "x"
                ]
                self.assertEqual(len(x_rules), 3)
                self.assertEqual(x_rules[0][0], "SpaceFN: shift x to Claude")
                self.assertEqual(x_rules[0][1]["from"]["modifiers"]["mandatory"], ["shift"])
                self.assertEqual(x_rules[0][1]["to"]["shell_command"], "open -a 'Claude'")
                self.assertIn({"type": "variable_if", "name": "spacefn_mode", "value": 1}, x_rules[0][1]["conditions"])
                self.assertEqual(x_rules[1][0], "SpaceFN: x to Codex")
                self.assertEqual(x_rules[1][1]["to"]["shell_command"], "open -a 'ChatGPT'")
                self.assertEqual(x_rules[2][0], "Hyper x to Codex")
                self.assertEqual(x_rules[2][1]["to"]["shell_command"], "open -a 'ChatGPT'")


class ClipboardTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-copy-test-")
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.clipboard = self.directory / "clipboard"
        self.marker = self.directory / "called"
        stub = self.directory / "pbcopy"
        stub.write_text('#!/bin/sh\n: > "$COPY_TEST_CALLED"\ncat > "$COPY_TEST_CLIPBOARD"\n')
        stub.chmod(0o700)
        self.env = dict(os.environ, PATH=f"{self.directory}:{os.environ['PATH']}",
                        COPY_TEST_CALLED=str(self.marker), COPY_TEST_CLIPBOARD=str(self.clipboard),
                        TMPDIR=str(self.directory))

    def test_empty_input_does_not_invoke_clipboard(self):
        self.clipboard.write_bytes(b"previous clipboard")
        subprocess.run(["sh", str(ROOT / "tmux/copy-if-not-empty.sh")], input=b"", env=self.env, check=True)
        self.assertEqual(self.clipboard.read_bytes(), b"previous clipboard")
        self.assertFalse(self.marker.exists())
        self.assertFalse(list(self.directory.glob("tmux-copy.*")))

    def test_nonempty_input_is_preserved_exactly(self):
        for selection in (b"hello", b"line one\nline two\n\n", b" \t", b"\n", "España 👋\n".encode(), b"x" * 100000):
            with self.subTest(selection_size=len(selection)):
                subprocess.run(["sh", str(ROOT / "tmux/copy-if-not-empty.sh")], input=selection, env=self.env, check=True)
                self.assertEqual(self.clipboard.read_bytes(), selection)
                self.assertTrue(self.marker.exists())
                self.assertFalse(list(self.directory.glob("tmux-copy.*")))

    @unittest.skipUnless(shutil.which("tmux"), "tmux is not installed")
    def test_tmux_configuration_routes_mouse_and_keyboard_copies(self):
        # A separate socket and detached session never touch the user's server.
        command = ["tmux", "-S", str(self.directory / "tmux.sock")]
        subprocess.run(command + ["-f", "/dev/null", "new-session", "-d", "-s", "copy-test", "/bin/cat"],
                       check=True, env=self.env)
        self.addCleanup(lambda: subprocess.run(command + ["kill-server"], capture_output=True))
        def tmux(*args):
            return subprocess.check_output(command + list(args), env=self.env, text=True).strip()
        tmux("source-file", str(ROOT / "tmux/tmux-osx.conf"))
        self.assertEqual(tmux("show-options", "-sv", "set-clipboard"), "off")
        self.assertIn("copy-if-not-empty.sh", tmux("show-options", "-sv", "copy-command"))
        bindings = tmux("list-keys", "-T", "prefix").splitlines()
        self.assertTrue(any("C-c " in line and "copy-if-not-empty.sh" in line for line in bindings))
        for table in ("copy-mode", "copy-mode-vi"):
            bindings = tmux("list-keys", "-T", table).splitlines()
            self.assertTrue(any("MouseDragEnd1Pane" in line and "copy-pipe-and-cancel" in line for line in bindings))
        # Avoid loading the user's shell startup files in the stubbed copy jobs.
        tmux("set-option", "-g", "default-shell", "/bin/sh")
        # Exercise the explicit copy binding with no tmux buffer at all.
        tmux("run-shell", "tmux save-buffer - 2>/dev/null | sh ~/dotfiles/tmux/copy-if-not-empty.sh")
        self.assertFalse(self.marker.exists())
        tmux("set-buffer", "nonempty buffer")
        tmux("run-shell", "tmux save-buffer - | sh ~/dotfiles/tmux/copy-if-not-empty.sh")
        self.assertEqual(self.clipboard.read_bytes(), b"nonempty buffer")


if __name__ == "__main__":
    unittest.main()
