#!/bin/bash

sudo apt update -y
sudo apt install -y nodejs npm

# Express App
mkdir /home/ubuntu/express
cd /home/ubuntu/express
npm init -y
npm install express axios

echo "
const express = require('express');
const axios = require('axios');
const app = express();

app.get('/', async (req, res) => {
  try {
    const response = await axios.get('http://${flask_private_ip}:5000');
    res.send('Frontend + ' + response.data);
  } catch (error) {
    res.send('Error connecting to Flask');
  }
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Express server running on port 3000');
});
" > app.js

nohup node app.js > express.log 2>&1 &