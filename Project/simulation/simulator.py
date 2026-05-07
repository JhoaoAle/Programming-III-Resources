from data.curriculum import SUBJECTS, CREDITOS

class Simulator:

    def __init__(self, agent, solver):
        self.agent = agent
        self.solver = solver

    def run(self, state):
        while True:
            selected = self.agent.choose_courses(state, self.solver)

            if not selected:
                print(f"Semester {state.current_semester}")
                print("No valid courses available (graduation or blocked state)")
                return state  # or break


            names = [SUBJECTS[i - 1] for i in selected]

            print(f"Semester {state.current_semester}")
            print(names)

            for c in selected:
                state.completed_courses.add(c)

            state.current_semester += 1