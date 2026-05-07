from data.curriculum import SUBJECTS
from solver.minizinc_solver import MiniZincSolver
from agents.balanced_agent import BalancedAgent
from simulation.simulator import Simulator
from domain.academic_state import AcademicState

solver = MiniZincSolver(
    "minizinc/model.mzn",
    "minizinc/data.dzn"
)

agent = BalancedAgent()

sim = Simulator(agent, solver)

state = state = AcademicState(
    current_semester=1,
    completed_courses=set(),
    failed_courses=set()
)

sim.run(state)