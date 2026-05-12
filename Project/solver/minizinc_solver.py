"""
MiniZincSolver: wraps the MiniZinc model + data file.

Key changes from original:
  - min_credits is passed as a parameter so the model can relax the
    floor when few courses remain (avoids UNSAT in late semesters).
  - Retries with progressively lower min_credits (12 → 8 → 4 → 1 → 0)
    before giving up, so the model always finds something if any
    feasible courses exist.
  - Falls back to a pure-Python greedy planner (using the prerequisite
    graph) when MiniZinc returns UNSAT even at min_credits=0.  This
    guarantees the simulation never blocks while reachable courses remain.
  - Uses result["taking"] directly instead of parsing the output string.
  - Returns [] (not None) so callers never have to guard against None.
"""
from typing import List

from minizinc import Instance, Model, Solver

from domain.academic_state import AcademicState
from data.course_graph import GRAPH
from data.curriculum import CREDITOS, SIMULTANEO


# Credit floors to try in order before falling back to Python planner
_CREDIT_FLOORS = [12, 8, 4, 1, 0]


class MiniZincSolver:

    def __init__(self, model_path: str, dzn_path: str):
        self.model = Model(model_path)
        self.model.add_file(dzn_path)
        self.gecode = Solver.lookup("gecode")

    # ------------------------------------------------------------------ #
    #  Public interface                                                    #
    # ------------------------------------------------------------------ #

    def solve(self, state: AcademicState) -> List[int]:
        """Return a list of 1-based course IDs for the next semester."""

        for floor in _CREDIT_FLOORS:
            plan = self._try_solve(state, min_credits=floor)
            if plan:
                if floor < 12:
                    print(f"  [Solver] Relaxed min_credits to {floor} "
                          f"— found {len(plan)} courses")
                return plan

        # MiniZinc failed at every floor — use the Python fallback
        print("  [Solver] MiniZinc UNSAT at all floors — using Python fallback")
        return self._python_fallback(state)

    # ------------------------------------------------------------------ #
    #  MiniZinc attempt                                                    #
    # ------------------------------------------------------------------ #

    def _try_solve(self, state: AcademicState, min_credits: int) -> List[int]:
        instance = Instance(self.gecode, self.model)
        instance["current_semester"] = state.current_semester
        instance["completed"] = [
            (c in state.completed_courses) for c in range(1, 61)
        ]
        instance["min_credits"] = min_credits

        result = instance.solve()

        if not result.status.has_solution():
            return []

        taking: List[bool] = result["taking"]
        return [i + 1 for i, t in enumerate(taking) if t]

    # ------------------------------------------------------------------ #
    #  Pure-Python greedy fallback                                         #
    # ------------------------------------------------------------------ #

    def _python_fallback(self, state: AcademicState) -> List[int]:
        """
        Greedy planner that respects prerequisites and simultaneous
        constraints without MiniZinc.  Picks courses by unlock value
        (highest first) and caps at 20 credits.
        """
        available = GRAPH.available_courses(state.completed_courses)

        if not available:
            return []

        # Enforce simultaneous pairs: both must be available or neither taken
        sim_pairs = {a: b for a, b in SIMULTANEO}
        sim_pairs.update({b: a for a, b in SIMULTANEO})

        # Sort by unlock value descending, credits ascending as tiebreak
        available.sort(
            key=lambda c: (
                -GRAPH.unlock_count(c, state.completed_courses),
                CREDITOS[c - 1],
            )
        )

        # Elective semester locks (mirror the MiniZinc constraints)
        sem = state.current_semester
        locked = set()
        if sem < 8:
            locked.update([57, 58])   # electivaA1, electivaA2
        if sem < 9:
            locked.update([59, 60])   # electivaB1, electivaB2

        chosen: List[int] = []
        chosen_set: set = set()
        total = 0

        for c in available:
            if c in locked:
                continue
            credits = CREDITOS[c - 1]

            # Check simultaneous partner
            partner = sim_pairs.get(c)
            partner_credits = CREDITOS[partner - 1] if partner else 0

            if partner and partner not in chosen_set:
                # Must take both together; check combined credit budget
                if partner not in available or partner in locked:
                    continue   # partner not available — skip this course too
                if total + credits + partner_credits > 20:
                    continue
                chosen.append(c)
                chosen.append(partner)
                chosen_set.add(c)
                chosen_set.add(partner)
                total += credits + partner_credits
            elif partner and partner in chosen_set:
                # Partner already chosen — this one comes along for free
                chosen.append(c)
                chosen_set.add(c)
                total += credits
            elif not partner:
                if total + credits > 20:
                    continue
                chosen.append(c)
                chosen_set.add(c)
                total += credits

        return chosen