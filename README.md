# Cartas Pokémon - Sistema BMVC (Bottle + MVC)

Sistema em Python com arquitetura MVC (Model, View, Controller) usando o micro-framework Bottle.

## Recursos
- **Portal:** login e criação de contas de usuário (model `user_account`).
- **Banco:** lista de cartas Pokémon (atributos: `nome`, `tipo`, `hp`).

## Estrutura
    app.py
    controllers/   portal_controller.py, banco_controller.py
    models/        user_account.py, carta.py
    views/         login.tpl, banco.tpl
    data/          arquivos JSON de persistência

## Como rodar
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    python3 app.py

Acesse http://localhost:8080/portal (usuário padrão: admin / senha: 123)

## READ (no sistema)
Após o login, a página /banco mostra as cartas com busca, filtro por tipo,
ordenação e atualização automática a cada 3 segundos.

## CREATE, UPDATE e DELETE (via cURL)

Criar conta:

    curl -X POST -d "username=ash" -d "password=pikachu" http://localhost:8080/portal/registro

Login (salva o cookie):

    curl -c cookies.txt -X POST -d "username=ash" -d "password=pikachu" http://localhost:8080/portal/login

CREATE:

    curl -b cookies.txt -X POST --data-urlencode "nome=Pikachu" --data-urlencode "tipo=Elétrico" -d "hp=60" http://localhost:8080/banco/cartas

UPDATE:

    curl -b cookies.txt -X PUT -d "hp=90" http://localhost:8080/banco/cartas/1

DELETE:

    curl -b cookies.txt -X DELETE http://localhost:8080/banco/cartas/1

## Códigos de resposta
201 criado | 400 dados inválidos | 401 não autenticado | 404 não encontrado | 409 usuário já existe
