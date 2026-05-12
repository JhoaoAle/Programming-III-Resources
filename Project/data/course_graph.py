"""
Prerequisite graph built directly from curriculum data.
Agents use this to measure how many future courses a given course unlocks.
"""
from typing import Dict, List, Set
 
from data.curriculum import PRECEDENCES, TOTAL_COURSES
 
 
class CourseGraph:
    def __init__(self):
        # adjacency: successors[pre] = {post, ...}
        self.successors: Dict[int, Set[int]] = {i: set() for i in range(1, TOTAL_COURSES + 1)}
        # adjacency: predecessors[post] = {pre, ...}
        self.predecessors: Dict[int, Set[int]] = {i: set() for i in range(1, TOTAL_COURSES + 1)}
 
        for pre, post in PRECEDENCES:
            self.successors[pre].add(post)
            self.predecessors[post].add(pre)
 
    def unlock_count(self, course_id: int, completed: Set[int]) -> int:
        """
        How many courses become available if course_id is completed,
        given the current completed set (not including course_id itself).
        A successor is 'unlocked' when all its prerequisites are in
        completed ∪ {course_id}.
        """
        hypothetical = completed | {course_id}
        count = 0
        for succ in self.successors[course_id]:
            if self.predecessors[succ].issubset(hypothetical):
                count += 1
        return count
 
    def all_prereqs_met(self, course_id: int, completed: Set[int]) -> bool:
        return self.predecessors[course_id].issubset(completed)
 
    def available_courses(self, completed: Set[int]) -> List[int]:
        """All courses whose prerequisites are fully satisfied."""
        return [
            c for c in range(1, TOTAL_COURSES + 1)
            if c not in completed and self.all_prereqs_met(c, completed)
        ]
 
 
# Module-level singleton
GRAPH = CourseGraph()
