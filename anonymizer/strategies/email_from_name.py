import random
import string
from typing import Any, Dict, Optional

from anonymizer.strategies.base import BaseAnonymizer


class EmailAnonymized(BaseAnonymizer):
    """
    Минимальная стратегия: генерирует случайный валидный email.
    Параметры (можно указывать в конфиге, но не обязательно):
        domain: str - домен (по умолчанию "example.com")
    """
    def __init__(self, params: Optional[Dict[str, Any]] = None):
        super().__init__(params)
        self.domain = self.params.get('domain', 'example.com')

    def _generate(self, value: Any, row: Optional[Dict[str, Any]] = None) -> str:
        # Детерминированная генерация на основе хеша исходного email
        seed = hash(value)
        rng = random.Random(seed)
        local_len = rng.randint(8, 12)
        local_part = ''.join(rng.choices(string.ascii_lowercase + string.digits, k=local_len))
        return f"{local_part}@{self.domain}"