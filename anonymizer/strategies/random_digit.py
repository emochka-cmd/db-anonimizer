import random
from typing import Any, Dict, Optional
from anonymizer.strategies.base import BaseAnonymizer

class RandomDigitsAnonymized(BaseAnonymizer):
    def __init__(self, params: Dict[str, Any]):
        super().__init__(params)
    
    def _generate(self, value: Optional[str], row: Optional[Dict] = None) -> str:
        length = self.params.get("length", 5)
        # Детерминированная генерация: используем хеш исходного значения как seed
        rng = random.Random(hash(value))
        return ''.join(str(rng.randint(0, 9)) for _ in range(length))