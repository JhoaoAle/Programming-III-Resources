"""
Coordinator: Nash Bargaining arbitration over agent proposals.

Given proposals from multiple agents, selects the plan that maximises
the product of (utility_i - disagreement_point_i) across all agents.

If no plan achieves a positive Nash product (e.g. all agents returned
empty proposals), returns the longest non-empty proposal as a fallback
so the simulation never stalls due to a coordination failure.
"""
import math
from typing import Dict, List, Optional

from agents.base_agent import BaseAgent


class Coordinator:

    def __init__(self, agents: List[BaseAgent]):
        self.agents = agents

    def arbitrate(
        self,
        proposals: Dict[str, List[int]],
        state,
    ) -> List[int]:
        # Collect unique non-empty plans (order-independent dedup)
        unique_plans: Dict[frozenset, List[int]] = {}
        for plan in proposals.values():
            if plan:
                key = frozenset(plan)
                if key not in unique_plans:
                    unique_plans[key] = plan

        if not unique_plans:
            return []

        best_plan: List[int] = []
        best_score: float = -math.inf
        # Fallback: longest plan regardless of Nash score
        fallback: List[int] = max(unique_plans.values(), key=len)

        for plan in unique_plans.values():
            score = self._nash_product(plan, state)
            if score > best_score:
                best_score = score
                best_plan = plan

        # If best Nash score is still -inf, return the fallback
        return best_plan if best_score > -math.inf else fallback

    def _nash_product(self, plan: List[int], state) -> float:
        product = 1.0
        for agent in self.agents:
            gain = agent.utility(plan, state) - agent.disagreement_point()
            if gain <= 0:
                return -math.inf
            product *= gain
        return product