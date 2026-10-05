import json
import os
from pathlib import Path
import plistlib
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
                self.assertEqual(len(x_rules), 5)
                self.assertEqual(x_rules[0][0], "SpaceFN: shift x to Claude")
                self.assertEqual(x_rules[0][1]["from"]["modifiers"]["mandatory"], ["shift"])
                self.assertEqual(x_rules[0][1]["to"]["shell_command"], "open -a 'Claude'")
                self.assertIn({"type": "variable_if", "name": "spacefn_mode", "value": 1}, x_rules[0][1]["conditions"])
                self.assertEqual(x_rules[1][0], "SpaceFN: x to Codex")
                self.assertEqual(x_rules[1][1]["to"]["shell_command"], "open -a 'ChatGPT'")
                self.assertEqual(x_rules[2][0], "Hyper x to Codex")
                self.assertEqual(x_rules[2][1]["to"]["shell_command"], "open -a 'ChatGPT'")

                # Evaluate the actual rule order for the Sweep and built-in keyboard.
                def launcher(modifiers, spacefn=False):
                    for _, manipulator in x_rules:
                        if manipulator.get("conditions") and not spacefn:
                            continue
                        spec = manipulator["from"].get("modifiers", {})
                        consumed = set()
                        for required in spec.get("mandatory", []):
                            choices = ({required} if required.startswith(("left_", "right_"))
                                       else {f"left_{required}", f"right_{required}"})
                            present = modifiers & choices
                            if not present:
                                break
                            consumed.update(present)
                        else:
                            optional = spec.get("optional", [])
                            if "any" in optional or modifiers <= consumed | set(optional):
                                return manipulator["to"]["shell_command"]
                    return None

                sweep = {"right_command", "right_control", "right_option"}
                for modifiers, spacefn, app in (
                    (sweep, False, "ChatGPT"),
                    (sweep | {"left_shift"}, False, "Claude"),
                    (sweep | {"right_shift"}, False, "Claude"),
                    (set(), True, "ChatGPT"),
                    ({"left_shift"}, True, "Claude"),
                    ({"left_command", "left_control", "left_option", "left_shift"}, False, "ChatGPT"),
                ):
                    self.assertEqual(launcher(modifiers, spacefn), f"open -a '{app}'")


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


class BluetoothRestartTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-bluetooth-test-")
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.calls = self.directory / "calls"
        blueutil = self.directory / "blueutil"
        blueutil.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$BLUETOOTH_TEST_CALLS"\n')
        blueutil.chmod(0o700)
        sleep = self.directory / "sleep"
        sleep.write_text('#!/bin/sh\nprintf "sleep %s\\n" "$*" >> "$BLUETOOTH_TEST_CALLS"\n')
        sleep.chmod(0o700)
        self.env = dict(os.environ, PATH=f"{self.directory}:{os.environ['PATH']}",
                        BLUETOOTH_TEST_CALLS=str(self.calls))

    def test_bluetooth_is_power_cycled(self):
        result = subprocess.run([str(ROOT / "bin/restart-bluetooth")], env=self.env,
                                check=True, capture_output=True, text=True)
        self.assertEqual(self.calls.read_text().splitlines(), ["--power 0", "sleep 2", "--power 1"])
        self.assertEqual(result.stdout, "Bluetooth restarted\n")

    def test_alfred_workflow_runs_the_restart_script(self):
        with (ROOT / "alfred/restart-bluetooth/info.plist").open("rb") as plist:
            workflow = plistlib.load(plist)
        keyword, script, notification = workflow["objects"]
        self.assertEqual(keyword["config"]["keyword"], "bt")
        self.assertTrue(keyword["config"]["withspace"])
        self.assertEqual(script["config"]["script"],
                         '"$alfred_workflow_bundlepath/restart-bluetooth"')
        self.assertEqual(notification["config"]["text"], "{query}")
        self.assertEqual(workflow["bundleid"], "com.dotfiles.restart-bluetooth")
        self.assertNotIn("createdby", workflow)

    @unittest.skipUnless(os.uname().sysname == "Darwin", "Alfred is only available on macOS")
    def test_alfred_installer_is_idempotent(self):
        alfred_app = self.directory / "Alfred 5.app"
        alfred_app.mkdir()
        preferences = self.directory / "Alfred.alfredpreferences"
        env = dict(self.env, ALFRED_APP_PATH=str(alfred_app),
                   ALFRED_PREFERENCES_DIR=str(preferences), DOTFILES_DIR=str(ROOT))
        installer = ROOT / "scripts/mac/install-alfred-workflows.sh"

        first = subprocess.run(["bash", str(installer)], env=env, check=True,
                               capture_output=True, text=True)
        workflow_link = (preferences / "workflows" /
                         "user.workflow.com.dotfiles.restart-bluetooth")
        self.assertTrue(workflow_link.is_symlink())
        self.assertEqual(workflow_link.resolve(), ROOT / "alfred/restart-bluetooth")
        self.assertEqual(first.stdout, "Linked Alfred Bluetooth workflow\n")

        second = subprocess.run(["bash", str(installer)], env=env, check=True,
                                capture_output=True, text=True)
        self.assertEqual(second.stdout, "Alfred Bluetooth workflow is already linked\n")


if __name__ == "__main__":
    unittest.main()
