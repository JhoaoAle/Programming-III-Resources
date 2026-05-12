from typing import Dict, List
 
from data.curriculum import SUBJECTS
 
 
class CourseRegistry:
    """Bidirectional mapping between 1-based course IDs and names."""
 
    def __init__(self):
        self.id_to_name: Dict[int, str] = {
            i + 1: name for i, name in enumerate(SUBJECTS)
        }
        self.name_to_id: Dict[str, int] = {
            name: i + 1 for i, name in enumerate(SUBJECTS)
        }
 
    def ids_to_names(self, ids: List[int]) -> List[str]:
        return [self.id_to_name[i] for i in ids]
 
    def names_to_ids(self, names: List[str]) -> List[int]:
        return [self.name_to_id[n] for n in names]
 
 
# Module-level singleton so callers don't have to instantiate
REGISTRY = CourseRegistry()
 
