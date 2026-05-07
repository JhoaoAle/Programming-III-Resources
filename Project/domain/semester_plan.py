from dataclasses import dataclass
from typing import List

@dataclass
class SemesterPlan:
    courses: List[int]

    @property
    def total_credits(self):
        return sum(c.credits for c in self.courses)