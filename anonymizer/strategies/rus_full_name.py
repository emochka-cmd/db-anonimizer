from anonymizer.strategies.base import BaseAnonymizer

class RusFullNameAnonymized(BaseAnonymizer):
    def __init__(self, params: dict):
        super().__init__(params)
        self._names = None

    def _load_names(self) -> list:
        file_path = self.params.get("source")
        if not file_path:
            raise ValueError("Не указан параметр 'source' для rus_full_name")
        with open(file_path, "r", encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip()]

    def _generate(self, value: str, row: dict = None) -> str:
        if self._names is None:
            self._names = self._load_names()
        if not self._names:
            raise ValueError("Список ФИО пуст")
        idx = abs(hash(value)) % len(self._names)
        return self._names[idx]