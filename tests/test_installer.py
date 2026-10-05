"""Exercise installer backups in an isolated home without installing packages."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class InstallerTests(unittest.TestCase):
    def test_conflicts_and_broken_links_preserve_every_backup(self):
        with tempfile.TemporaryDirectory(prefix="dotfiles-install-test-") as directory:
            area = Path(directory)
            source = area / 'repository file'
            source.write_text('repository content')
            destination = area / 'home file'
            destination.write_text('personal configuration')
            (area / 'home file.backup').write_text('older backup')
            env = dict(os.environ, TEST_SOURCE=str(source), TEST_DEST=str(destination))
            command = ['bash', '-c', 'source "$1"; checklink "$TEST_SOURCE" "$TEST_DEST"; checklink "$TEST_SOURCE" "$TEST_DEST"', '_', str(ROOT / 'install.sh')]
            subprocess.run(command, env=env, check=True, capture_output=True)
            self.assertEqual(source.read_text(), 'repository content')
            self.assertEqual((area / 'home file.backup').read_text(), 'older backup')
            self.assertEqual((area / 'home file.backup.1').read_text(), 'personal configuration')
            self.assertEqual(destination.resolve(), source.resolve())
            self.assertFalse((area / 'home file.backup.2').exists())
            destination.unlink()
            destination.symlink_to(area / 'missing target')
            subprocess.run(command, env=env, check=True, capture_output=True)
            self.assertTrue((area / 'home file.backup.2').is_symlink())
            self.assertEqual(destination.resolve(), source.resolve())

    def test_shell_lines_are_literal_idempotent_and_separated(self):
        with tempfile.TemporaryDirectory(prefix="dotfiles-install-test-") as directory:
            target = Path(directory) / 'zshrc'
            target.write_text('# existing without newline')
            line = 'export PATH="$HOME/go/bin:$PATH"'
            env = dict(os.environ, TEST_TARGET=str(target), TEST_LINE=line)
            subprocess.run(['bash', '-c', 'source "$1"; createifno "$TEST_TARGET" "$TEST_LINE"; createifno "$TEST_TARGET" "$TEST_LINE"', '_', str(ROOT / 'install.sh')], env=env, check=True)
            self.assertEqual(target.read_text().splitlines(), ['# existing without newline', line])
