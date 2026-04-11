# import random
from typing import Any, Dict, Optional

from anonymizer.strategies.base import BaseAnonymizer


class RandomWordsAnonymized(BaseAnonymizer):
    def __init__(self, params: Dict[str, Any]):
        super().__init__(params)
        self._words = None

    def _load_words(self):
        path = self.params.get("source")
        if not path:
            raise ValueError("Не указан 'source' для random_words")
        with open(path, "r", encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip()]

    # нововедение для детерминизаци
    def _generate(self, value: Any, row: Optional[Dict] = None) -> str:
        if self._words is None:
            self._words = self._load_words()
        if not self._words:
            raise ValueError("Список слов пуст")
        # Детерминированный выбор индекса на основе хеша исходного значения
        idx = abs(hash(value)) % len(self._words)
        return self._words[idx]

    """
    def anonymize(self, value: Optional[str], row: Optional[Dict] = None) -> str:
        if self._words is None:
            self._words = self._load_words()
        return random.choice(self._words)
    """
