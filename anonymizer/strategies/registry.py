# anonymizer/strategies/registry.py
from typing import Dict, Type
 
from .base import BaseAnonymizer
 
 
class StrategyRegistry:
    """Реестр всех доступных стратегий анонимизации."""
 
    _strategies: Dict[str, Type[BaseAnonymizer]] = {}
 
    @classmethod
    def register(cls, name: str, strategy_class: Type[BaseAnonymizer]) -> None:
        """Регистрирует стратегию под указанным именем."""
        cls._strategies[name] = strategy_class
 
    @classmethod
    def get(cls, name: str) -> Type[BaseAnonymizer]:
        """
        Возвращает класс стратегии по имени.
        Бросает KeyError с сообщением, если стратегия не найдена.
        """
        try:
            return cls._strategies[name]
        except KeyError:
            available = ", ".join(sorted(cls._strategies)) or "<нет зарегистрированных>"
            raise KeyError(
                f"Стратегия '{name}' не найдена в реестре. "
                f"Доступные: {available}"
            ) from None
 
    @classmethod
    def list(cls):
        return list(cls._strategies.keys())
 