"""
Wires together:
  - MiniZincSolver   (hard constraint satisfaction)
  - BalancedAgent    (credit-load balance utility)
  - FastAgent        (unlock-count utility)
  - SafeAgent        (low-load risk-aversion utility)
  - Coordinator      (Nash Bargaining arbitration)
  - Simulator        (semester loop with pass/fail outcomes)
"""
from solver.minizinc_solver import MiniZincSolver
from agents.balanced_agent import BalancedAgent
from agents.fast_agent import FastAgent
from agents.safe_agent import SafeAgent
from simulation.simulator import Simulator
from domain.academic_state import AcademicState

import warnings
warnings.filterwarnings("ignore", module="minizinc.*")

def main():
    # ── Solver ────────────────────────────────────────────────────────
    solver = MiniZincSolver(
        model_path="minizinc/model.mzn",
        dzn_path="minizinc/data.dzn",
    )

    # ── Agents ────────────────────────────────────────────────────────
    agents = [
        BalancedAgent(),   # anchors load near 16 credits
        FastAgent(),       # maximises future course unlocks
        SafeAgent(),       # keeps load light to reduce failure risk
    ]

    # ── Simulator ─────────────────────────────────────────────────────
    sim = Simulator(
        agents=agents,
        solver=solver,
        max_semesters=20,
        random_seed=42,     # change for different outcome samples
    )

    # ── Initial state ─────────────────────────────────────────────────
    state = AcademicState(
        current_semester=1,
        completed_courses=set(),
        failed_courses=set(),
    )

    # ── Run ───────────────────────────────────────────────────────────
    sim.run(state)


if __name__ == "__main__":
    main()