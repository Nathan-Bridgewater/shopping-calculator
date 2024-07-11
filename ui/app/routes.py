from app import app
from flask import render_template, request, redirect, url_for

ALLOWED_EXTENSIONS = {'png', 'jpg'}

def isAllowedFileExtension(filename):
  if '.' not in filename:
    return False
  extension = filename.split('.', 1)[1].lower()
  return extension in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET', 'POST'])
def index():
  return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
  receipt = request.files['receipt']
  return redirect(url_for('index'))