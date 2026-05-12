from dataclasses import dataclass
from typing import List
 
from data.curriculum import CREDITOS
 
 
@dataclass
class SemesterPlan:
    courses: List[int]   # list of 1-based course IDs
 
    @property
    def total_credits(self) -> int:
        # CREDITOS is 0-indexed; course IDs are 1-based
        return sum(CREDITOS[c - 1] for c in self.courses)
 
    def __len__(self) -> int:
        return len(self.courses)
 
