#!/usr/bin/env bash
# Bootstrap do projeto Meu Oratório.
# Seguro: NÃO sobrescreve arquivos existentes; só adiciona o que faltar.
set -euo pipefail

PROJ="$HOME/meuoratorio"
ROOT="https://raw.githubusercontent.com/edgararcoverde-cyber/backup-25may20260951pm/claude/new-app-setup-fnq8r1/meuoratorio"
DOCS=(fundacao-projeto fontes-conteudo mvp-conteudo-instrucoes ingestao-oracoes-santos ingestao-biblia email-licenciamento-cnbb decisoes-design)
UI=(tokens.ts tailwind-preset.js)

echo "==> Projeto: $PROJ"
mkdir -p "$PROJ/docs" "$PROJ/packages/ui"
cd "$PROJ"

echo "==> Baixando docs (sem sobrescrever os que já existem)..."
for f in "${DOCS[@]}"; do
  if [ -f "docs/$f.md" ]; then
    echo "    (ja existe) docs/$f.md"
  else
    curl -fsSL "$ROOT/docs/$f.md" -o "docs/$f.md" && echo "    baixado  docs/$f.md"
  fi
done

echo "==> Baixando design tokens (packages/ui)..."
for f in "${UI[@]}"; do
  if [ -f "packages/ui/$f" ]; then
    echo "    (ja existe) packages/ui/$f"
  else
    curl -fsSL "$ROOT/packages/ui/$f" -o "packages/ui/$f" && echo "    baixado  packages/ui/$f"
  fi
done

echo "==> Inicializando git (se necessario)..."
if [ ! -d .git ]; then
  git init -q
  git branch -M main 2>/dev/null || true
fi

git add docs packages
if git diff --cached --quiet; then
  echo "    nada novo para commitar"
else
  git commit -q -m "Adiciona docs e design tokens (Meu Oratorio)"
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
