import ast
from minizinc import Instance, Model, Solver

class MiniZincSolver:

    def __init__(self, model_path, dzn_path):
        self.model = Model(model_path)
        self.model.add_file(dzn_path)
        self.solver = Solver.lookup("gecode")

    def solve(self, state):

        instance = Instance(self.solver, self.model)

        instance["current_semester"] = state.current_semester

        completed = [False] * 60
        for c in state.completed_courses:
            completed[c - 1] = True

        instance["completed"] = completed

        result = instance.solve()

        try:
            return ast.literal_eval(str(result).strip())
        except Exception:
            return None