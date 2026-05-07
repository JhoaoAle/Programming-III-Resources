from typing import Dict, List

class CourseRegistry:
    def __init__(self, subjects: List[str]):
        # 1-based indexing to match MiniZinc SUBJECTS
        self.id_to_name: Dict[int, str] = {
            i + 1: name for i, name in enumerate(subjects)
        }

        self.name_to_id: Dict[str, int] = {
            name: i + 1 for i, name in enumerate(subjects)
        }

    def ids_to_names(self, ids: List[int]) -> List[str]:
        return [self.id_to_name[i] for i in ids]

    def names_to_ids(self, names: List[str]) -> List[int]:
        return [self.name_to_id[n] for n in names]