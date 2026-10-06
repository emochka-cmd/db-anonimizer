from typing import Any, Dict, Optional

from anonymizer.strategies.base import BaseAnonymizer


class FixedValueAnonymized(BaseAnonymizer):
    def __init__(self, params: Dict[str, Any]):
        super().__init__(params)

    def _generate(self, value: Optional[str], row: Optional[Dict] = None) -> str:
            return self.params.get("value", "")
