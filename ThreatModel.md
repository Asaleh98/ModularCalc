# Threatspec Project Threat Model

A threatspec project.


# Diagram
![Threat Model Diagram](ThreatModel.md.png)



# Exposures

## Distrubuted denial of service against CalcApp:Web:Server:login
Not implementing login attempt lockouts

```
# @exposes #login to #ds with not implementing login attempt lockouts

@flask_app.route('/login')
def login_page():
    return render_template('login.html')


```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## Bruteforceattack against CalcApp:Web:Server:login
Not using login attempt lockouts

```
#@exposes #login to #bfa with not using login attempt lockouts
@flask_app.route('/login')
def login_page():
    return render_template('login.html')

def create_token(username, password):

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## Sql injection against CalcApp:Web:Server:login:DB
Not sanitizing user inputs or using prepared statements

```
# @exposes #db to #sqli with not sanitizing user inputs or using prepared statements

@flask_app.route('/authenticate', methods = ['POST'])
def authenticate_users():
    data = request.form
    username = data['username']

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## Cross-site-scripting against CalcApp:Web:Server:Calculator
Not sanitizing user inputs in

```
# @exposes #calculator to #xss with NOT sanitizing user inputs in


@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():
    print(request.form)

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## Bufferoverflow against CalcApp:Web:Server:Calculator
Not implementing #lc

```
# @exposes #calculator to #bufferoverflow with not implementing #lc

@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():
    print(request.form)
    number_1 = request.form.get('number_1', type = int)

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1


# Acceptances


# Transfers


# Mitigations

## Cross-site-scripting against CalcApp:Web:Server:Calculator mitigated by Inputvalidation


```
# @mitigates #calculator against #xss with #iv


@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():
    print(request.form)

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## Bufferoverflow against CalcApp:Web:Server:Calculator mitigated by Lengthchecking


```
# @mitigates #calculator against #bufferoverflow with #lc

@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():
    print(request.form)
    number_1 = request.form.get('number_1', type = int)

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1


# Reviews


# Connections

## External:guest With CalcApp:Web:Server:Index
HTTP-GET

```
# @connects #guest with #index with HTTP-GET
@flask_app.route('/')
def index_page():
    print(request.headers)
    isUserLoggedIn = False
    if 'token' in request.cookies:

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:Index With External:guest
HTTP-GET

```
# @connects #index with #guest with HTTP-GET
@flask_app.route('/')
def index_page():
    print(request.headers)
    isUserLoggedIn = False
    if 'token' in request.cookies:

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:Index With CalcApp:Web:Server:login
HTTP-GET

```
# @connects #index with #login with HTTP-GET


@flask_app.route('/login')
def login_page():
    return render_template('login.html')

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:login With CalcApp:Web:Server:login:DB
SQL-Request

```
# @connects #login with #db with SQL-Request

@flask_app.route('/authenticate', methods = ['POST'])
def authenticate_users():
    data = request.form
    username = data['username']

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:login:DB With CalcApp:Web:Server:login
SQL-Response

```
# @connects #db with #login with SQL-Response

@flask_app.route('/authenticate', methods = ['POST'])
def authenticate_users():
    data = request.form
    username = data['username']

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:login To CalcApp:Web:Server:Calculator
HTTP-POST

```
# @connects #login to #calculator with HTTP-POST



@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:Calculator To CalcApp:Web:Server:Logout
HTTP-GET

```
# @connects #calculator to #logout with HTTP-GET



@flask_app.route('/calculate2', methods = ['POST'])
def calculate_post2():

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:Web:Server:Logout To CalcApp:Web:Server:Index
HTTP-GET

```
# @connects #logout to #index with HTTP-GET
@flask_app.route('/logout', methods = ['GET'])
def logout():
    response = make_response(redirect('/'))
    response.delete_cookie('token')
    return response

```
/home/kali/Desktop/secure_rest_calculator-main/app/main.py:1

## CalcApp:VPC:Subnet To CalcApp:Web:Server
Network

```
# @connects #subnet to #web_server with Network
resource "aws_instance" "cyber94_calculator2_asaleh_webserver_tf" {
    ami = var.var_aws_ami_ubuntu_1804
    instance_type = "t2.micro"
    subnet_id = var.var_web_subnet_id
    associate_public_ip_address = true

```
/home/kali/Desktop/secure_rest_calculator-main/Terraform-infra-modular/modules/webserver/main.tf:1


# Components

## CalcApp:Web:Server:Calculator

## CalcApp:Web:Server:login

## CalcApp:Web:Server:login:DB

## External:guest

## CalcApp:Web:Server:Index

## CalcApp:Web:Server:Logout

## CalcApp:VPC:Subnet

## CalcApp:Web:Server


# Threats

## Cross-site-scripting


## Bufferoverflow


## Distrubuted denial of service


## Bruteforceattack


## Sql injection



# Controls

## Inputvalidation

## Lengthchecking
