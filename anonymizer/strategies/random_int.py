from typing import Any, Dict, Optional
from anonymizer.strategies.base import BaseAnonymizer

class RandomIntAnonymized(BaseAnonymizer):
    def __init__(self, params: Dict[str, Any]):
        super().__init__(params)
    
    def _generate(self, value: Optional[int], row: Optional[Dict] = None) -> int:
        min_val = self.params.get("min", 0)
        max_val = self.params.get("max", 1000000)
        if isinstance(value, (int, float)):
            r = (hash(value) & 0xFFFFFFFF) % (max_val - min_val + 1)
        else:
            r = (hash(str(value)) & 0xFFFFFFFF) % (max_val - min_val + 1)
        return min_val + r