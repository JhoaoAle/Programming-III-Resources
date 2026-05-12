
from abc import ABC, abstractmethod
from typing import List, Optional
 
 
class BaseAgent(ABC):
    """
    All agents must implement:
      - choose_courses: given state + solver, return a list of course IDs
      - utility: score a proposed plan (used by the Coordinator)
      - disagreement_point: minimum acceptable utility (Nash reference)
    """
 
    @abstractmethod
    def choose_courses(self, state, solver) -> List[int]:
        """Return a list of 1-based course IDs for the next semester."""
 
    def utility(self, plan: List[int], state) -> float:
        """
        Score a plan from this agent's perspective.
        Default: number of courses selected (override in subclasses).
        """
        return float(len(plan))
 
    def disagreement_point(self) -> float:
        """Minimum utility this agent considers acceptable."""
        return 0.0
 
    @property
    def name(self) -> str:
        return self.__class__.__name__
 
