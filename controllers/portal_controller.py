from bottle import Bottle, request, response, redirect, template
from models.user_account import UserAccount

SECRET = "troque-esta-chave-secreta"
portal = Bottle()

def logged_user():
    return request.get_cookie("session", secret=SECRET)

@portal.get('/portal')
def home():
    return redirect('/banco' if logged_user() else '/portal/login')

@portal.get('/portal/login')
def login_form():
    return template('login', erro=None)

@portal.post('/portal/login')
def login():
    u = request.forms.getunicode('username')
    p = request.forms.getunicode('password')
    if UserAccount.authenticate(u, p):
        response.set_cookie("session", u, secret=SECRET, path='/')
        if 'curl' in request.headers.get('User-Agent', '').lower():
            return "OK\n"
        return redirect('/banco')
    response.status = 401
    return template('login', erro="Credenciais inválidas")

# CRIAR CONTA (via cURL)
@portal.post('/portal/registro')
def registro():
    u = (request.forms.getunicode('username') or "").strip()
    p = request.forms.getunicode('password') or ""
    if not u or len(p) < 3:
        response.status = 400
        return {"erro": "informe username e password (mínimo 3 caracteres)"}
    if not UserAccount.create(u, p):
        response.status = 409
        return {"erro": f"usuário '{u}' já existe"}
    response.status = 201
    return {"ok": True, "username": u}

@portal.get('/portal/logout')
def logout():
    response.delete_cookie("session", path='/')
    return redirect('/portal/login')
