from anonymizer.strategies.base import BaseAnonymizer


class RusSurnameAnonymized(BaseAnonymizer):
    def __init__(self, params: dict):
        super().__init__(params)
        self._surnames = None

    def _load_surnames(self) -> list:
        file_path = self.params.get("source")
        if not file_path:
            raise ValueError("Не указан параметр 'source' для rus_surname")
        with open(file_path, "r", encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip()]

    def _generate(self, value: str, row: dict = None) -> str:
        if self._surnames is None:
            self._surnames = self._load_surnames()
        if not self._surnames:
            raise ValueError("Список фамилий пуст")
        idx = abs(hash(value)) % len(self._surnames)
        return self._surnames[idx]
