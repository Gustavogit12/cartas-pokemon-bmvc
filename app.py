import os
from bottle import Bottle, TEMPLATE_PATH, run
from controllers.portal_controller import portal
from controllers.banco_controller import banco

TEMPLATE_PATH.insert(0, os.path.join(os.path.dirname(__file__), 'views'))

app = Bottle()
app.merge(portal)
app.merge(banco)

if __name__ == '__main__':
    run(app, host='0.0.0.0', port=8080, debug=True, reloader=True)
