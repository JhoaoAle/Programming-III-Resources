from dataclasses import dataclass, field
from typing import Set, Dict
 
 
@dataclass
class AcademicState:
    current_semester: int
    completed_courses: Set[int]
    failed_courses: Set[int]
    current_gpa: float = 0.0
    # Maps course_id -> estimated pass probability (used by Bayesian agents)
    course_pass_probs: Dict[int, float] = field(default_factory=dict)
 
    def has_completed(self, course_id: int) -> bool:
        return course_id in self.completed_courses
 
    def mark_passed(self, course_id: int) -> None:
        self.completed_courses.add(course_id)
        self.failed_courses.discard(course_id)
 
    def mark_failed(self, course_id: int) -> None:
        self.failed_courses.add(course_id)
 
    def clone(self) -> "AcademicState":
        return AcademicState(
            current_semester=self.current_semester,
            completed_courses=set(self.completed_courses),
            failed_courses=set(self.failed_courses),
            current_gpa=self.current_gpa,
            course_pass_probs=dict(self.course_pass_probs),
        )
 
