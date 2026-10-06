import random
from typing import Any, Dict, Optional
from anonymizer.strategies.base import BaseAnonymizer

class CompanyNameAnonymized(BaseAnonymizer):
    def __init__(self, params: Dict[str, Any]):
        super().__init__(params)
        self._words = None

    def _load_words(self):
        path = self.params.get("words_source")
        if not path:
            raise ValueError("Не указан 'words_source'")
        with open(path, "r", encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip()]

    def _generate(self, 
        value: Optional[str], 
        row: Optional[Dict] = None
    ) -> str:
        if self._words is None:
            self._words = self._load_words()
        if not self._words:
            raise ValueError("Список слов пуст")

        min_w = self.params.get("min_words", 1)
        max_w = self.params.get("max_words", 3)
        preserve = self.params.get("preserve_length", False)
        sep = self.params.get("separator", " ")
        seed = hash(value)

        if preserve and value:
            target_len = len(value.strip())
            best_name = None
            best_diff = float('inf')
            for n in range(min_w, max_w + 1):
                rng = random.Random(seed + n)
                candidate = sep.join(rng.sample(self._words, min(n, len(self._words))))
                diff = abs(len(candidate) - target_len)
                if diff < best_diff:
                    best_diff = diff
                    best_name = candidate
            return best_name
        else:
            n = random.Random(seed).randint(min_w, max_w)
            rng = random.Random(seed + n)
            return sep.join(rng.sample(self._words, min(n, len(self._words))))

