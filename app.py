# This code creates a simple web server using Flask, which will respond to HTTP requests on port 5000
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hi world!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)