from dataclasses import dataclass
from unittest import TestCase


class CanaryTest(TestCase):
    def test_always_passes(self):
        self.assertTrue(True)

    def test_also_passes(self):
        self.assertFalse(False)


@dataclass
class Something:
    a: int = 1
