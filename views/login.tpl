<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Portal Pokémon - Login</title>
<style>
  body { margin:0; min-height:100vh; display:flex; align-items:center; justify-content:center;
         font-family:system-ui,sans-serif; background:linear-gradient(135deg,#ef5350,#b71c1c); }
  .box { background:#fff; padding:32px; border-radius:16px; width:300px; text-align:center;
         box-shadow:0 10px 30px rgba(0,0,0,.35); }
  .ball { width:60px; height:60px; border-radius:50%; margin:0 auto 12px;
          background:linear-gradient(#e53935 46%,#222 46% 54%,#fff 54%); border:3px solid #222; }
  input,button { width:100%; box-sizing:border-box; padding:10px; margin-top:10px;
                 border-radius:8px; border:1px solid #bbb; font-size:15px; }
  button { background:#e53935; color:#fff; border:0; cursor:pointer; font-weight:bold; }
  button:hover { background:#c62828; }
  .erro { color:#c62828; font-size:14px; }
</style>
</head>
<body>
  <div class="box">
    <div class="ball"></div>
    <h2>Portal Pokémon</h2>
    % if erro:
    <p class="erro">{{erro}}</p>
    % end
    <form method="post" action="/portal/login">
      <input name="username" placeholder="usuário" required>
      <input name="password" type="password" placeholder="senha" required>
      <button>Entrar</button>
    </form>
  </div>
</body>
</html>
