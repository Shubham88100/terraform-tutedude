#!/bin/bash

sudo apt update -y
sudo apt install -y python3 nodejs npm
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

# Express App
mkdir /home/ubuntu/express
cd /home/ubuntu/express
npm init -y
npm install express

echo "
const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('Express Frontend Running'));
app.listen(3000, '0.0.0.0');
" > app.js

nohup node app.js > express.log 2>&1 &