#!/usr/bin/env bash
# Bootstrap do projeto Meu Oratório.
# Seguro: NÃO sobrescreve arquivos existentes; só adiciona o que faltar.
set -euo pipefail

PROJ="$HOME/meuoratorio"
BASE="https://raw.githubusercontent.com/edgararcoverde-cyber/backup-25may20260951pm/claude/new-app-setup-fnq8r1/meuoratorio/docs"
FILES=(fontes-conteudo mvp-conteudo-instrucoes ingestao-oracoes-santos ingestao-biblia email-licenciamento-cnbb decisoes-design)

echo "==> Projeto: $PROJ"
mkdir -p "$PROJ/docs"
cd "$PROJ"

echo "==> Baixando docs (sem sobrescrever os que já existem)..."
for f in "${FILES[@]}"; do
  if [ -f "docs/$f.md" ]; then
    echo "    (ja existe) docs/$f.md"
  else
    curl -fsSL "$BASE/$f.md" -o "docs/$f.md" && echo "    baixado  docs/$f.md"
  fi
done

echo "==> Inicializando git (se necessario)..."
if [ ! -d .git ]; then
  git init -q
  git branch -M main 2>/dev/null || true
fi

git add docs
if git diff --cached --quiet; then
  echo "    nada novo para commitar"
else
  git commit -q -m "Adiciona docs de conteudo e licenciamento (Meu Oratorio)"
  echo "    commit criado"
fi

echo "==> Repositorio remoto..."
if git remote get-url origin >/dev/null 2>&1; then
  git push -u origin "$(git symbolic-ref --short HEAD)" && echo "    push feito"
elif command -v gh >/dev/null 2>&1; then
  gh repo create meuoratorio --private --source=. --remote=origin --push \
    && echo "    repo criado e enviado via gh CLI"
else
  echo "    >> Falta so conectar ao GitHub. Faca:"
  echo "       1) Crie um repo VAZIO em https://github.com/new  (nome: meuoratorio)"
  echo "       2) git remote add origin https://github.com/SEU_USUARIO/meuoratorio.git"
  echo "       3) git push -u origin main"
fi

echo "==> Concluido."
