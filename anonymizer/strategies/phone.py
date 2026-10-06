import random
from typing import Any, Dict, Optional

from anonymizer.strategies.base import BaseAnonymizer


class RusPhoneAnonymized(BaseAnonymizer):
    def __init__(self, params: dict) -> None:
        super().__init__(params)
        self.mask = params.get("phone_mask", "+7XXX XXX XX XX")

    def _generate(self, value: Any, row: Optional[Dict] = None) -> str:
        # Генерируем цифры детерминированно на основе хеша исходного номера
        seed = hash(value)
        rng = random.Random(seed)
        return "".join(
            str(rng.randint(0, 9)) if ch.upper() == "X" else ch for ch in self.mask
        )

    """
    def anonymize(self, value: str, row: dict = None) -> str:
        return ''.join(
            str(random.randint(0, 9)) if ch.upper() == 'X' else ch
            for ch in self.mask
        )
    """
