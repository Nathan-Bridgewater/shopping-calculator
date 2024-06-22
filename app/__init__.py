from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)
migrate = Migrate(app, db)
login = LoginManager(app)
# Tells Flask what the login page is so
# We can automatically redirect to login from
# Protected pages
login.login_view = 'login' 
 
from app import routes, models

