from flask import render_template
from app import app

@app.route('/')
@app.route('/index')
def index():
  user = {'username': 'Nathan'}
  posts = [
        {
            'author': {'username': 'John'},
            'body': 'Beautiful day in Portland!'
        },
        {
            'author': {'username': 'Susan'},
            'body': 'The Avengers movie was so cool!'
        },
        {
            'author': {'username': 'Eleanor'},
            'body': 'Made in Chelsea is great!'
        }
    ]
  return render_template('index.html', title='Home', posts=posts, user=user)

