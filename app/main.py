from flask import Flask, make_response, request, render_template, redirect, jsonify
from random import random
import datetime
import jwt
import calc_functions as calc_functions

SECRET_KEY = "C7E2F9D46E92DCF2234D18BEF8C6D"
flask_app = Flask(__name__)

# @component External:guest(#guest)
def verify_token(token):
    if token:
        decoded_token = jwt.decode(token, SECRET_KEY, "HS256")
        print(decoded_token)
        # Check whther the information in decoded_token is correct or not

        return True # if the information is correct, otherwise return False
    else:
        return False
# @component CalcApp:Web:Server:Index(#index)
# @connects #guest with #index with HTTP-GET
# @connects #index with #guest with HTTP-GET
@flask_app.route('/')
def index_page():
    print(request.headers)
    isUserLoggedIn = False
    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])

    if isUserLoggedIn:
        return "Welcome back to the website"
    else:
        user_id = random()
        print(f"User ID: {user_id}")
        resp = make_response(render_template('index.html'))
        resp.set_cookie('user_id', str(user_id))
        return resp

@flask_app.route('/help')
def help_page():
    return "This is the help page"
# @component CalcApp:Web:Server:login(#login)
# @connects #index with #login with HTTP-GET

# @threat Distrubuted Denial of service (#ds)
# @exposes #login to #ds with not implementing login attempt lockouts

#@threat BruteForceAttack (#bfa)
#@exposes #login to #bfa with not using login attempt lockouts
@flask_app.route('/login')
def login_page():
    return render_template('login.html')

def create_token(username, password):
    validity = datetime.datetime.utcnow() + datetime.timedelta(days=15)
    print(validity)
    token = jwt.encode({'user_id': 123154, 'username': username, 'exp': validity}, SECRET_KEY, "HS256")
    return token

# @component CalcApp:Web:Server:login:DB(#db)
# @connects #login with #db with SQL-Request
# @connects #db with #login with SQL-Response
# @threat SQL injection (#sqli)
# @exposes #db to #sqli with not sanitizing user inputs or using prepared statements

@flask_app.route('/authenticate', methods = ['POST'])
def authenticate_users():
    data = request.form
    username = data['username']
    password = data['password']

    # check whether the username and password are correct
    user_token = create_token(username, password)

    resp = make_response(redirect('/calculator'))
    #resp.set_cookie("loggedIn", "True")
    resp.set_cookie('token', user_token)
    return resp

@flask_app.route('/calculator', methods = ['GET'])
def calculator_get():
    isUserLoggedIn = False
    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])

    if isUserLoggedIn:
        return render_template("calculator.html")
    else:
        resp = make_response(redirect('/login'))
        return resp

@flask_app.route('/calculate', methods = ['POST'])
def calculate_post():
    number_1 = request.form.get('number_1', type = int)
    number_2 = request.form.get('number_2', type = int)
    operation= request.form.get('operation')

    result = calc_functions.process(number_1, number_2, operation)

    return str(result)
# @component CalcApp:Web:Server:Calculator(#calculator)
# @connects #login to #calculator with HTTP-POST
# @connects #calculator to #logout with HTTP-GET

# @threat Cross-Site-Scripting (#xss)
# @exposes #calculator to #xss with NOT sanitizing user inputs in
# @control InputValidation (#iv)
# @mitigates #calculator against #xss with #iv

# @threat BufferOverflow (#bufferoverflow)
# @exposes #calculator to #bufferoverflow with not implementing #lc
# @control LengthChecking (#lc)
# @mitigates #calculator against #bufferoverflow with #lc

@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():
    print(request.form)
    number_1 = request.form.get('number_1', type = int)
    number_2 = request.form.get('number_2', type = int)
    operation= request.form.get('operation', type= str)

    result = calc_functions.process(number_1, number_2, operation)

    print(result)
    response_data = {
        'data': result
    }
    return make_response(jsonify(response_data))
# @component CalcApp:Web:Server:Logout(#logout)
# @connects #logout to #index with HTTP-GET
@flask_app.route('/logout', methods = ['GET'])
def logout():
    response = make_response(redirect('/'))
    response.delete_cookie('token')
    return response

if __name__ == "__main__":
    print("This is a Secure REST API Server")
    flask_app.run(host="0.0.0.0", debug = True, ssl_context=('cert/cert.pem', 'cert/key.pem'))
