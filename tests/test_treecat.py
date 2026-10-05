import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class TreecatTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-treecat-test-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / 'one.TXT').write_bytes(b'first\n')
        (self.root / 'two file.md').write_bytes(b'second\n')
        (self.root / 'empty.txt').touch()

    def run_treecat(self, *args):
        return subprocess.check_output(
            ['bash', str(ROOT / 'bin/treecat'), str(self.root), *args],
            text=True)

    def test_stats_count_all_files_and_bytes(self):
        output = self.run_treecat('--stats', '--no-content')
        self.assertIn('Total files found: 3\n', output)
        self.assertIn('Total size: 13 bytes\n', output)
        self.assertIn('two file.md', output)

    def test_extension_filter_preserves_listing_and_counts_printed_content(self):
        output = self.run_treecat('--stats', '--ext', 'txt')
        self.assertIn('first\n', output)
        self.assertNotIn('second\n', output)
        self.assertIn('two file.md', output)
        self.assertIn('Files with content printed: 2\n', output)
        self.assertIn('Total files found: 3\n', output)

    def test_exclusion_and_empty_files_work_with_system_bash(self):
        excluded = self.root / 'skip'
        excluded.mkdir()
        (excluded / 'secret.txt').write_text('excluded')
        output = subprocess.check_output(
            ['/bin/bash', str(ROOT / 'bin/treecat'), str(self.root), '--stats', '-x', 'skip'],
            text=True)
        self.assertNotIn('excluded', output)
        self.assertIn('Total files found: 3\n', output)
        self.assertIn('Total size: 13 bytes\n', output)
