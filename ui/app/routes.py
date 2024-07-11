from app import app
from flask import render_template, request, redirect, url_for

@app.route('/', methods=['GET', 'POST'])
def index():
  return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
  file = request.files['receipt']
  print(file.read())
  return redirect(url_for('index'))