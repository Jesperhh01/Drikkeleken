from app.services.question_manager import QuestionManager
from app.services.troll_manager import TrollManager


question_manager = QuestionManager()
troll_manager = TrollManager()

__all__ = ['question_manager', 'troll_manager']

