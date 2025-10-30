from flask import Blueprint, render_template, request, jsonify
from .. import services

bp = Blueprint('main', __name__)
_question_manager = services.question_manager
_troll_manager = services.troll_manager

@bp.route('/')
def index():
    return render_template('index.html')


@bp.route('/gamehost')
def gamehost():
    return render_template('game.html')

@bp.route('/questions')
def questions():
    return render_template('questions.html')

@bp.route('/challenges')
def challenges():
    return render_template('challenges.html')

@bp.route("/add_question", methods=["POST"])
def add_question():
    question = request.form.get("question")
    _question_manager.add_question(question)
    return "", 204

@bp.route("/get_challenge", methods=["GET"])
def get_challenge():
    challenge = _question_manager.display_question()
    return jsonify({"challenge": challenge})

@bp.route("/get_troll_image", methods=["GET"])
def get_troll_image():
    image_url = _troll_manager.get_troll_image()
    return jsonify({"url": image_url})


