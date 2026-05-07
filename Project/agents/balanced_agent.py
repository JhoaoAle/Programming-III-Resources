from agents.base_agent import BaseAgent

class BalancedAgent:

    def __init__(self):
        pass

    def choose_courses(self, state, solver):
        return solver.solve(state)