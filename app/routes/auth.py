from flask import Blueprint, render_template, redirect, url_for, request, flash
from werkzeug.security import check_password_hash, generate_password_hash

bp = Blueprint('auth', __name__, url_prefix='/auth')


@bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Login logik her
        pass
    return render_template('login.html')


@bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # Registrerings logik her
        pass
    return render_template('register.html')


@bp.route('/logout')
def logout():
    # Logout logik her
    return redirect(url_for('main.index'))

