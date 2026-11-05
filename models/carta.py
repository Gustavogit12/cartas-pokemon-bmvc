import json, os

FILE = os.path.join(os.path.dirname(__file__), '..', 'data', 'cartas.json')

class Carta:
    @staticmethod
    def all():
        if not os.path.exists(FILE):
            return []
        with open(FILE, encoding='utf-8') as f:
            return json.load(f)

    @staticmethod
    def _save(data):
        with open(FILE, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

    @staticmethod
    def create(nome, tipo, hp, criado_por):
        data = Carta.all()
        novo_id = max([c["id"] for c in data], default=0) + 1
        item = {"id": novo_id, "nome": nome, "tipo": tipo,
                "hp": hp, "criado_por": criado_por}
        data.append(item)
        Carta._save(data)
        return item

    @staticmethod
    def update(id, nome=None, tipo=None, hp=None):
        data = Carta.all()
        for c in data:
            if c["id"] == id:
                if nome: c["nome"] = nome
                if tipo: c["tipo"] = tipo
                if hp is not None: c["hp"] = hp
                Carta._save(data)
                return c
        return None

    @staticmethod
    def delete(id):
        data = Carta.all()
        nova = [c for c in data if c["id"] != id]
        Carta._save(nova)
        return len(nova) < len(data)
