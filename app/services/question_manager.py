import random


class QuestionManager:
    def __init__(self):
        self.questions = []

    def add_question(self, question):
        if question:
            self.questions.append(question)

    def display_question(self):
        if self.questions:
            random_index = random.randint(0, len(self.questions) - 1)
            question = self.questions[random_index]
            del self.questions[random_index]
            return question
        else:
            return "Tomt for spørsmål"

