"""
AWS Elastic Beanstalk application entry point.
EB looks for 'application' variable in application.py
"""
from app import create_app
from config import config
import os

# Get config from environment variable, default to production
config_name = os.environ.get('FLASK_ENV', 'production')
application = create_app(config[config_name])

if __name__ == '__main__':
    application.run()

