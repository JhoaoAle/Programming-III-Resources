"""
SafeAgent: keeps credit load low to minimise failure risk.
Utility is highest when the semester is light (close to MIN_CREDITS).
"""
from typing import List

from agents.base_agent import BaseAgent
from data.curriculum import CREDITOS


class SafeAgent(BaseAgent):
    """
    Utility = 1 / (total_credits - MIN_CREDITS + 1).
    Lighter semesters score higher.
    """

    MIN_CREDITS = 12   # hard lower bound from MiniZinc model

    def choose_courses(self, state, solver) -> List[int]:
        return solver.solve(state)

    def utility(self, plan: List[int], state) -> float:
        if not plan:
            return self.disagreement_point()
        total = sum(CREDITOS[c - 1] for c in plan)
        return 1.0 / (total - self.MIN_CREDITS + 1)

    def disagreement_point(self) -> float:
        return 1.0 / (20 - self.MIN_CREDITS + 1)   # worst acceptable = 20 credits