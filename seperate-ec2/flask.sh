#!/bin/bash

sudo apt update -y
sudo apt install -y python3
sudo apt install -y python3-flask


# Flask App
mkdir /home/ubuntu/flask
cd /home/ubuntu/flask
echo "
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Flask Backend Running'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
" > app.py

nohup python3 app.py > flask.log 2>&1 &