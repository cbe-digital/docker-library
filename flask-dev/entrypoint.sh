#!/bin/bash

cd "$FLASK_HOME/flask_app"

if [ -f requirements.txt ]; then
  echo "Install dependencies..."
  sudo pip install -r requirements.txt
fi

echo "Start Flask server..."
gunicorn --worker-class eventlet -w 1 $FLASK_PROJECT:app --daemon

sudo service nginx start
