from abc import ABC, abstractmethod

class BaseAgent(ABC):

    @abstractmethod
    def choose_courses(self, state, solver):
        pass