import sys
from pathlib import Path

from anonymizer.strategies import StrategyRegistry
from anonymizer.strategies.rus_name import RusNameAnonymized

strategy_class = StrategyRegistry.get('rus_name')
