from dataclasses import dataclass
from typing import Set

@dataclass
class AcademicState:
    current_semester: int
    completed_courses: Set[int]
    failed_courses: Set[int]
    current_gpa: float = 0.0

    def has_completed(self, course_id: int) -> bool:
        return course_id in self.completed_courses