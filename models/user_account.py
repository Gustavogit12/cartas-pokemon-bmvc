import json, os, hashlib

FILE = os.path.join(os.path.dirname(__file__), '..', 'data', 'users.json')

def _hash(texto):
    return hashlib.sha256(texto.encode()).hexdigest()

class UserAccount:
    @staticmethod
    def _load():
        if not os.path.exists(FILE):
            data = [{"username": "admin", "password": _hash("123")}]
            UserAccount._save(data)
            return data
        with open(FILE, encoding='utf-8') as f:
            return json.load(f)

    @staticmethod
    def _save(data):
        with open(FILE, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

    @staticmethod
    def authenticate(username, password):
        if not username or not password:
            return False
        return any(u["username"] == username and u["password"] == _hash(password)
                   for u in UserAccount._load())

    @staticmethod
    def create(username, password):
        """Retorna False se o usuário já existe."""
        data = UserAccount._load()
        if any(u["username"] == username for u in data):
            return False
        data.append({"username": username, "password": _hash(password)})
        UserAccount._save(data)
        return True
