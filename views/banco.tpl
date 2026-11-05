<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Banco de Cartas Pokémon</title>
<style>
  body { margin:0; font-family:system-ui,sans-serif; background:#f1f3f6; color:#222; }
  header { background:#e53935; color:#fff; padding:14px 24px; display:flex;
           justify-content:space-between; align-items:center; }
  header a { color:#fff; }
  main { max-width:1000px; margin:20px auto; padding:0 16px; }
  .barra { display:flex; gap:10px; flex-wrap:wrap; margin-bottom:12px; }
  .barra input, .barra select { padding:10px; border-radius:8px; border:1px solid #bbb; font-size:15px; }
  .barra input { flex:1; min-width:180px; }
  .status { font-size:13px; color:#666; margin-bottom:12px; }
  .grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(210px,1fr)); gap:16px; }
  .carta { border-radius:14px; padding:14px; color:#fff; cursor:pointer;
           box-shadow:0 4px 12px rgba(0,0,0,.25); transition:transform .15s; min-height:130px; }
  .carta:hover { transform:translateY(-4px) scale(1.02); }
  .topo { display:flex; justify-content:space-between; align-items:baseline; }
  .nome { font-size:19px; font-weight:bold; }
  .hp { font-weight:bold; }
  .tipo { display:inline-block; margin-top:10px; background:rgba(255,255,255,.3);
          padding:3px 10px; border-radius:20px; font-size:13px; }
  .detalhe { display:none; margin-top:10px; font-size:13px; border-top:1px solid rgba(255,255,255,.5); padding-top:8px; }
  .carta.aberta .detalhe { display:block; }
  .vazio { text-align:center; color:#777; padding:40px; }
</style>
</head>
<body>
<header>
  <h2 style="margin:0">Cartas Pokémon</h2>
  <span>Olá, {{user}} | <a href="/portal/logout">Sair</a></span>
</header>
<main>
  <div class="barra">
    <input id="busca" placeholder="Buscar por nome...">
    <select id="filtro"><option value="">Todos os tipos</option></select>
    <select id="ordem">
      <option value="id">Ordem de cadastro</option>
      <option value="nome">Nome (A-Z)</option>
      <option value="hp">HP (maior primeiro)</option>
    </select>
  </div>
  <div class="status" id="status">Carregando...</div>
  <div class="grid" id="grid"></div>
</main>

<script>
const CORES = {
  fogo:'#e8590c', agua:'#1c7ed6', 'água':'#1c7ed6', planta:'#2f9e44', eletrico:'#f08c00',
  'elétrico':'#f08c00', psiquico:'#ae3ec9', 'psíquico':'#ae3ec9', normal:'#868e96',
  gelo:'#15aabf', lutador:'#c92a2a', fantasma:'#5f3dc4', dragao:'#364fc7', 'dragão':'#364fc7',
  terra:'#a67c52', voador:'#4dabf7', inseto:'#74b816', veneno:'#9c36b5'
};
const grid = document.getElementById('grid');
const busca = document.getElementById('busca');
const filtro = document.getElementById('filtro');
const ordem = document.getElementById('ordem');
const status = document.getElementById('status');
let cartas = [];
let abertas = new Set();

function cor(tipo) { return CORES[tipo.toLowerCase()] || '#495057'; }

function atualizarFiltro() {
  const atual = filtro.value;
  const tipos = [...new Set(cartas.map(c => c.tipo))].sort();
  filtro.innerHTML = '<option value="">Todos os tipos</option>';
  tipos.forEach(t => {
    const o = document.createElement('option');
    o.value = t; o.textContent = t;
    filtro.appendChild(o);
  });
  filtro.value = tipos.includes(atual) ? atual : '';
}

function render() {
  const q = busca.value.toLowerCase();
  let lista = cartas.filter(c =>
    c.nome.toLowerCase().includes(q) && (!filtro.value || c.tipo === filtro.value));
  if (ordem.value === 'nome') lista.sort((a, b) => a.nome.localeCompare(b.nome));
  if (ordem.value === 'hp') lista.sort((a, b) => b.hp - a.hp);

  grid.innerHTML = '';
  if (lista.length === 0) {
    const v = document.createElement('div');
    v.className = 'vazio';
    v.textContent = cartas.length ? 'Nenhuma carta encontrada.' : 'Nenhuma carta cadastrada ainda.';
    grid.appendChild(v);
  }
  lista.forEach(c => {
    const el = document.createElement('div');
    el.className = 'carta' + (abertas.has(c.id) ? ' aberta' : '');
    el.style.background = 'linear-gradient(135deg,' + cor(c.tipo) + ',#222 220%)';

    const topo = document.createElement('div'); topo.className = 'topo';
    const n = document.createElement('span'); n.className = 'nome'; n.textContent = c.nome;
    const h = document.createElement('span'); h.className = 'hp'; h.textContent = c.hp + ' HP';
    topo.append(n, h);

    const t = document.createElement('span'); t.className = 'tipo'; t.textContent = c.tipo;

    const d = document.createElement('div'); d.className = 'detalhe';
    d.textContent = 'ID #' + c.id + ' • cadastrada por ' + c.criado_por;

    el.append(topo, t, d);
    el.onclick = () => {
      abertas.has(c.id) ? abertas.delete(c.id) : abertas.add(c.id);
      el.classList.toggle('aberta');
    };
    grid.appendChild(el);
  });
  status.textContent = lista.length + ' de ' + cartas.length + ' cartas • atualiza sozinho a cada 3s';
}

async function carregar() {
  try {
    const r = await fetch('/banco/cartas.json');
    if (r.status === 401) { location = '/portal/login'; return; }
    cartas = await r.json();
    atualizarFiltro();
    render();
  } catch (e) {
    status.textContent = 'Sem conexão com o servidor...';
  }
}

busca.oninput = render;
filtro.onchange = render;
ordem.onchange = render;
carregar();
setInterval(carregar, 3000);
</script>
</body>
</html>
