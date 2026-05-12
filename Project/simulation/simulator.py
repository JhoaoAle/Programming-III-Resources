"""
Simulator: runs the full multi-agent academic planning loop.

Each semester:
  1. Each agent broadcasts its intended plan (cheap-talk signal).
  2. The Coordinator picks the Nash-optimal plan from all proposals.
  3. Pass/fail outcomes are sampled (simple probability model).
  4. State is updated and the next semester begins.

Graduation condition: ALL 60 courses completed.
Blocked condition: no courses available in the prerequisite graph
                   (should never happen with the solver fallback).
"""
import random
from typing import Dict, List

from data.curriculum import CREDITOS
from data.course_utils import REGISTRY
from data.course_graph import GRAPH
from agents.base_agent import BaseAgent
from agents.coordinator import Coordinator
from domain.academic_state import AcademicState

TOTAL_COURSES = 60


def _pass_probability(total_credits: int) -> float:
    """Higher load → lower pass probability."""
    base = 0.92
    overload_penalty = max(0, (total_credits - 16)) * 0.02
    return max(0.60, base - overload_penalty)


class Simulator:

    def __init__(
        self,
        agents: List[BaseAgent],
        solver,
        max_semesters: int = 25,
        random_seed: int = 42,
    ):
        self.agents = agents
        self.solver = solver
        self.coordinator = Coordinator(agents)
        self.max_semesters = max_semesters
        random.seed(random_seed)

    def run(self, state: AcademicState) -> AcademicState:
        print("=" * 65)
        print("  ACADEMIC PLANNING SIMULATION")
        print(f"  Agents : {', '.join(a.name for a in self.agents)}")
        print(f"  Goal   : complete all {TOTAL_COURSES} courses")
        print("=" * 65)

        while state.current_semester <= self.max_semesters:

            remaining = TOTAL_COURSES - len(state.completed_courses)

            # ── Graduation check ───────────────────────────────────────
            if remaining == 0:
                print(f"\n{'='*65}")
                print(f"  GRADUATED after semester {state.current_semester - 1}!")
                print(f"{'='*65}")
                break

            # ── Dead-end check (graph level, not solver level) ─────────
            available_in_graph = GRAPH.available_courses(state.completed_courses)
            if not available_in_graph:
                print(f"\nSemester {state.current_semester}: curriculum graph "
                      f"is blocked with {remaining} courses remaining.")
                print("  This indicates a data error in the prerequisite graph.")
                break

            # ── 1. Cheap-talk: each agent proposes a plan ──────────────
            proposals: Dict[str, List[int]] = {}
            for agent in self.agents:
                proposal = agent.choose_courses(state, self.solver)
                proposals[agent.name] = proposal if proposal else []

            # ── 2. Coordinator picks Nash-optimal plan ─────────────────
            chosen_plan = self.coordinator.arbitrate(proposals, state)

            # Safety: if coordinator returns empty (e.g. all agents got [])
            # ask the solver directly with no agent layer
            if not chosen_plan:
                chosen_plan = self.solver.solve(state)

            if not chosen_plan:
                print(f"\nSemester {state.current_semester}: solver returned "
                      f"no plan despite {len(available_in_graph)} available "
                      f"courses. Check model constraints.")
                break

            # ── 3. Display ─────────────────────────────────────────────
            total_credits = sum(CREDITOS[c - 1] for c in chosen_plan)
            names = REGISTRY.ids_to_names(chosen_plan)

            print(f"\n── Semester {state.current_semester}  "
                  f"({total_credits} cr, {len(chosen_plan)} courses, "
                  f"{remaining} remaining) " + "─" * 20)

            for agent in self.agents:
                u = agent.utility(chosen_plan, state)
                prop_len = len(proposals.get(agent.name, []))
                print(f"  [{agent.name:16s}] proposed {prop_len:2d} courses "
                      f"| utility: {u:.2f}")

            print(f"  Chosen:")
            for name in names:
                print(f"    • {name}")

            # ── 4. Pass/fail outcomes ──────────────────────────────────
            p_pass = _pass_probability(total_credits)
            passed, failed = [], []
            for c in chosen_plan:
                if random.random() < p_pass:
                    state.mark_passed(c)
                    passed.append(c)
                else:
                    state.mark_failed(c)
                    failed.append(c)

            if failed:
                print(f"  ✗ Failed : {REGISTRY.ids_to_names(failed)}")
            print(f"  ✓ Passed : {len(passed)}/{len(chosen_plan)}  "
                  f"| Total completed: {len(state.completed_courses)}/{TOTAL_COURSES}")

            state.current_semester += 1

        else:
            completed = len(state.completed_courses)
            print(f"\nReached semester limit ({self.max_semesters}) with "
                  f"{completed}/{TOTAL_COURSES} courses completed.")

        return state