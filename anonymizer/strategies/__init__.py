# anonymizer/strategies/__init__.py
# импортирует все классы и регистрирует их

# импорты:
#from .base import BaseAnonymizer
from .registry import StrategyRegistry
from .rus_name import RusNameAnonymized
from .rus_surname import RusSurnameAnonymized
from .email_from_name import EmailAnonymized
from .phone import RusPhoneAnonymized
from .rus_full_name import RusFullNameAnonymized
from .company_name import CompanyNameAnonymized
from .random_digit import RandomDigitsAnonymized
from .random_int import RandomIntAnonymized
from .project_name import ProjectNameAnonymized
from .random_words import RandomWordsAnonymized
from .random_string import RandomStringAnonymized
from .fixed_value import FixedValueAnonymized

# регистрация
StrategyRegistry.register('rus_name', RusNameAnonymized)
StrategyRegistry.register('rus_surname', RusSurnameAnonymized)
StrategyRegistry.register('email_from_name', EmailAnonymized)
StrategyRegistry.register('rus_full_name', RusFullNameAnonymized)
StrategyRegistry.register('phone', RusPhoneAnonymized)
StrategyRegistry.register('company_name', CompanyNameAnonymized)
StrategyRegistry.register('random_digits', RandomDigitsAnonymized)
StrategyRegistry.register('random_int', RandomIntAnonymized)
StrategyRegistry.register('project_name', ProjectNameAnonymized)
StrategyRegistry.register('random_words', RandomWordsAnonymized)
StrategyRegistry.register('random_string', RandomStringAnonymized)
StrategyRegistry.register('fixed_value', FixedValueAnonymized)