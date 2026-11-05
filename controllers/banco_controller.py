import json
from bottle import Bottle, request, response, template, redirect
from models.carta import Carta
from controllers.portal_controller import logged_user

banco = Bottle()

def nao_autenticado():
    response.status = 401
    return {"erro": "não autenticado. Faça login em /portal/login"}

def campo(nome):
    valor = request.forms.getunicode(nome)
    return valor.strip() if valor else ""

def ler_hp():
    """Retorna (hp, erro). hp=None se não foi enviado."""
    bruto = campo('hp')
    if not bruto:
        return None, None
    if not bruto.isdigit() or not (1 <= int(bruto) <= 999):
        return None, "hp deve ser um número entre 1 e 999"
    return int(bruto), None

# READ (página no navegador)
@banco.get('/banco')
def listar():
    if not logged_user():
        return redirect('/portal/login')
    return template('banco', user=logged_user())

# READ (dados usados pela página, atualiza sozinha)
@banco.get('/banco/cartas.json')
def cartas_json():
    if not logged_user():
        return nao_autenticado()
    response.content_type = 'application/json; charset=utf-8'
    return json.dumps(Carta.all(), ensure_ascii=False)

# CREATE (cURL)
@banco.post('/banco/cartas')
def criar():
    user = logged_user()
    if not user:
        return nao_autenticado()
    nome, tipo = campo('nome'), campo('tipo')
    hp, erro = ler_hp()
    if erro or not nome or not tipo or hp is None:
        response.status = 400
        return {"erro": erro or "nome, tipo e hp são obrigatórios"}
    response.status = 201
    return Carta.create(nome, tipo, hp, user)

# UPDATE (cURL, opcional)
@banco.put('/banco/cartas/<id:int>')
def atualizar(id):
    if not logged_user():
        return nao_autenticado()
    nome, tipo = campo('nome'), campo('tipo')
    hp, erro = ler_hp()
    if erro or (not nome and not tipo and hp is None):
        response.status = 400
        return {"erro": erro or "informe nome, tipo e/ou hp"}
    item = Carta.update(id, nome, tipo, hp)
    if item:
        return item
    response.status = 404
    return {"erro": f"carta {id} não encontrada"}

# DELETE (cURL)
@banco.delete('/banco/cartas/<id:int>')
def deletar(id):
    if not logged_user():
        return nao_autenticado()
    if Carta.delete(id):
        return {"ok": True, "removido": id}
    response.status = 404
    return {"erro": f"carta {id} não encontrada"}
