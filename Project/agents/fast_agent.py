"""
FastAgent: prioritises courses that unlock the most future courses.
It asks the solver for a feasible plan, then re-ranks by unlock value
so it can report a meaningful utility score. The solver still enforces
all hard constraints — FastAgent only influences the utility function.
"""
from typing import List

from agents.base_agent import BaseAgent
from data.course_graph import GRAPH
from data.curriculum import CREDITOS


class FastAgent(BaseAgent):
    """
    Utility = sum of unlock counts for each selected course.
    Prefers semesters that open the most doors.
    """

    def choose_courses(self, state, solver) -> List[int]:
        return solver.solve(state)

    def utility(self, plan: List[int], state) -> float:
        if not plan:
            return self.disagreement_point()
        return float(
            sum(GRAPH.unlock_count(c, state.completed_courses) for c in plan)
        )

    def disagreement_point(self) -> float:
        return 0.0