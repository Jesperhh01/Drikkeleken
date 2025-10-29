from flask import Blueprint, render_template, request
from .. import services

bp = Blueprint('main', __name__)
_question_manager = services.question_manager

@bp.route('/')
def index():
    return render_template('index.html')


@bp.route('/gamehost')
def gamehost():
    return render_template('game.html')

@bp.route('/joingame')
def joingame():
    return render_template('joinggame.html')

@bp.route("/add_question", methods=["POST"])
def add_question():
    question = request.form.get("question")
    _question_manager.add_question(question)
    return "", 204




