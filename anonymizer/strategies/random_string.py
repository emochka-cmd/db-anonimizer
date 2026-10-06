import random
import string
from typing import Any, Dict, Optional

from anonymizer.strategies.base import BaseAnonymizer


class RandomStringAnonymized(BaseAnonymizer):
    def __init__(self, params: Dict[str, Any]):
        super().__init__(params)
        self._chars = string.ascii_letters + string.digits  # a-z, A-Z, 0-9

    def _generate(self, value: Optional[str], row: Optional[Dict] = None) -> str:
        if self.params.get("preserve_length", False) and value:
            length = len(str(value))
        else:
            length = self.params.get("length", 10)
        if length < 1:
            length = 1
        seed = hash(value)
        rng = random.Random(seed)
        return "".join(rng.choices(self._chars, k=length))
