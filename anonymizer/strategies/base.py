# anonymizer/strategies/base.py
import abc

from typing import Any, Optional, Dict, Hashable


class BaseAnonymizer(abc.ABC):
    """Абстрактный класс для всех стратегий анонимизации. """

    def __init__(self, 
        params: Optional[Dict[str, Any]] = None) -> None:
        self.params = params or {}

        # Нововедение для детерминированния
        self._cache: Dict[Hashable, Any] = {}
    
    @abc.abstractmethod
    def _generate(self, value: Any, row: Optional[Dict] = None) -> Any:
        """Генерирует новое анонимизированное значение для исходного value."""
        pass

    def anonymize(self, 
        value: Any,
        row: Optional[Dict] = None
    ) -> Any:
        """Возвращает анонимизированное значение детерминированно (с кэшированием)."""
        if value is None:
            return None

        # Используем само значение как ключ (для неизменяемых типов)
        if value in self._cache:
            return self._cache[value]
        new_value = self._generate(value, row)
        self._cache[value] = new_value
        return new_value


    def _get_param(self, key: str, default=None):
        return self.params.get(key, default)
