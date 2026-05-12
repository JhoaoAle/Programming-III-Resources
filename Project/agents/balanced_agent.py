
from typing import List
 
from agents.base_agent import BaseAgent
from data.curriculum import CREDITOS
 
 
class BalancedAgent(BaseAgent):
    """
    Passes the academic state straight to the MiniZinc solver.
    The solver enforces all constraints and returns a feasible plan.
    Utility: prefers plans whose credit load is close to the target (16).
    """
 
    TARGET_CREDITS = 16
 
    def choose_courses(self, state, solver) -> List[int]:
        return solver.solve(state)
 
    def utility(self, plan: List[int], state) -> float:
        if not plan:
            return self.disagreement_point()
        total = sum(CREDITOS[c - 1] for c in plan)
        # Penalise deviation from target load
        return 100.0 - abs(total - self.TARGET_CREDITS)
 
    def disagreement_point(self) -> float:
        return 70.0   # accept plans within ±30 credits of target
 
