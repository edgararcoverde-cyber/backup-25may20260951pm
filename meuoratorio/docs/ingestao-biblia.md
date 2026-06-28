# Ingestão da Bíblia — Meu Oratório

> Instrução executável para o Claude Code montar a Bíblia católica em pt do app
> a partir da tradução **Figueiredo** (domínio público), sem depender da CNBB/editoras.
> Estratégia: texto livre + estruturação automatizada + modernização SÓ de grafia.
> Ler junto com `docs/fontes-conteudo.md`.

---

## 0. Realidade e meta

- A Bíblia oficial da CNBB e a Ave Maria são **proprietárias** (Fase 2 licenciada).
- A única Bíblia **católica, completa (73 livros) e domínio público** em pt é a de
  **Pe. Antônio Pereira de Figueiredo** (tradução da Vulgata, séc. XVIII).
- ❌ NÃO existe Figueiredo pronto em JSON. ✅ Existe em PDF de texto e em texto web.
- **Meta:** Figueiredo → JSON estruturado (livro/capítulo/versículo), com grafia atual.
- ⚠️ **Só o TEXTO bíblico.** Descartar comentários/notas (a edição 1950 tem notas no *Index*).
- ⚠️ **Modernizar SÓ a grafia (Nível A)** — nunca a gramática/vocabulário (seria nova tradução).

---

## 1. Fontes (texto livre) e o teste decisivo

| # | Fonte | Tipo | Observação |
|---|---|---|---|
| B1 | `evangelizandocommaria.com.br` — "Bíblia Sagrada Ano Santo 1950 (Figueiredo)" | PDF | Edição digitada — provável camada de texto |
| B2 | `obrascatolicas.com/livros/Biblia/BibliaFigueiredo.pdf` | PDF | Verificar camada de texto |
| B3 | Internet Archive — `biblia-figueiredo` (e edição 1866) | PDF/scan | Scans antigos → provavelmente exigem OCR |
| B4 | `bibliacatolica.com.br` | Texto web (cap./versículo) | Texto PD, mas site de terceiro — preferir PDF |

### Teste OBRIGATÓRIO antes de tudo (decide se há OCR):
```bash
pdftotext arquivo-figueiredo.pdf - | sed -n '1,60p'
```
- Saiu **texto legível** (versículos) → ✅ SEM OCR. Seguir o pipeline normal.
- Saiu **vazio/lixo** → é imagem; ou trocar de fonte (preferir B1/B2 digitados) ou OCR
  (`ocrmypdf` / `tesseract -l por`) como último recurso.

> Priorizar PDFs **digitados** (B1/B2). Evitar scans (B3) se houver alternativa com texto.

---

## 2. Pipeline de ingestão (ordem)

1. **Baixar** o PDF escolhido para `data/raw/biblia/`.
2. **Testar camada de texto** (comando acima). Registrar resultado.
3. **Extrair** texto: `pdftotext -layout`. Salvar bruto em `data/raw/biblia/figueiredo.txt`.
4. **Descartar comentários/notas**: manter apenas o texto dos versículos; remover rodapés,
   introduções, notas de comentário (a parte problemática). Heurística: notas costumam vir
   em blocos separados/numeração diferente — validar por amostragem.
5. **Parsear** em estrutura livro → capítulo → versículo (regex de "Cap." / numeração de versículo).
6. **Modernizar grafia (Nível A)** — seção 3 (automatizado, dicionário + regras).
7. **Validar** estrutura (seção 5).
8. **Gravar** seed em `supabase/seed/bible/figueiredo/` (um JSON por livro) + índice.

---

## 3. Modernização de grafia — Nível A (SÓ ortografia)

> Trocar a ESCRITA antiga pela atual, SEM mudar a palavra nem o sentido. Nunca mexer em
> gramática (`vós`, conjugações) — isso seria nova tradução e exigiria aprovação eclesiástica.

Exemplos de regras/dicionário:
```
elle→ele  ella→ela  delle→dele  Christo→Cristo  Jesu Christo→Jesus Cristo
sancto→santo  propheta→profeta  Espirito→Espírito  Deos→Deus  hum→um  huma→uma
escripto→escrito  baptismo→batismo  phariseu→fariseu  cathedra→cátedra
```
- Implementar como tabela de substituição + regras de acentuação; revisar casos ambíguos.
- Preservar nomes próprios e termos teológicos; em dúvida, **não alterar** e marcar p/ revisão.

---

## 4. Esquema de dados

### Tabelas (migração Supabase)
```sql
create table bible_books (
  id text primary key,          -- 'gn','ex',... 'tb' (Tobias), '1mc' (1 Macabeus)
  name text not null,           -- 'Gênesis'
  testament text not null,      -- 'AT' | 'NT'
  is_deuterocanonical boolean default false,
  canon_order int not null,     -- ordem do cânon católico (73 livros)
  chapters int not null
);

create table bible_verses (
  id uuid primary key default gen_random_uuid(),
  book_id text references bible_books(id),
  chapter int not null,
  verse int not null,
  text text not null,
  translation text not null default 'figueiredo',
  source text not null default 'dominio-publico',
  license text not null default 'public-domain',
  modernized boolean default true,    -- grafia atualizada (Nível A)
  review_status text default 'approved',
  unique (translation, book_id, chapter, verse)
);
```

### Cânon católico — 73 livros (conferir presença!)
- **AT (46):** incluindo os **deuterocanônicos**: Tobias, Judite, Sabedoria, Eclesiástico
  (Sirácida), Baruc, 1 e 2 Macabeus, + acréscimos a Ester e a Daniel.
- **NT (27).**
- A validação DEVE confirmar que os 7 deuterocanônicos estão presentes (é o que diferencia
  do cânon protestante).

### Item de seed (exemplo)
```json
{
  "book_id": "tb", "book": "Tobias", "chapter": 1, "verse": 1,
  "text": "...", "translation": "figueiredo",
  "source": "dominio-publico", "license": "public-domain",
  "source_ref": "Figueiredo, ed. 1950 (texto sem comentários)",
  "modernized": true, "review_status": "approved"
}
```

---

## 5. Validação (automatizada)

- **Cânon:** 73 livros presentes; os 7 deuterocanônicos existem (`is_deuterocanonical = true`).
- **Contagem:** nº de capítulos por livro bate com referência conhecida (tolerância a
  diferenças de versificação católica — registrar divergências, não falhar cego).
- **Integridade:** nenhum versículo vazio; sem blocos de comentário vazando no `text`.
- **Amostragem humana:** revisar N versículos por livro (ex.: 5) + todos os sinalizados pela
  modernização. NÃO revisar os ~31 mil um a um.
- **Relatório de cobertura:** livros/capítulos/versículos importados e itens sinalizados.

---

## 6. Regras de qualidade

- **Texto, não comentário:** zero notas/comentários da edição (questão do *Index*).
- **Só grafia (Nível A):** proibido alterar gramática/vocabulário do texto sagrado.
- **Rastreabilidade:** todo versículo com `source`, `source_ref`, `license`, `modernized`.
- **Domínio público confirmado:** Figueiredo (autor †1797) é PD; registrar edição usada.
- **Offline-first:** seed embarcado por livro (JSON), funciona sem rede.
- **Revisão:** ideal validação por alguém qualificado antes do lançamento público.

---

## 7. Prompt pronto para colar no Claude Code

> Cole no Claude Code em plan mode (Shift+Tab).

```
Leia docs/fontes-conteudo.md e docs/ingestao-biblia.md.

Implemente a ingestão da Bíblia católica (tradução Figueiredo, domínio público)
seguindo À RISCA a instrução. NÃO use texto da CNBB/Ave Maria. Use APENAS o
texto bíblico (descarte comentários/notas). Modernize SOMENTE a grafia
(Nível A) — nunca a gramática/vocabulário.

Execute nesta ordem:
1. Crie data/raw/biblia/ e scripts/ingest/bible/ com:
   a) check-text-layer.sh — roda pdftotext e diz se o PDF tem camada de texto.
   b) parse-figueiredo.ts — extrai texto (pdftotext -layout), descarta
      comentários, parseia em livro/capítulo/versículo.
   c) modernize-spelling.ts — aplica a tabela de grafia (Nível A), marcando
      casos ambíguos para revisão (não altera gramática).
2. Crie a migração supabase/migrations com bible_books e bible_verses (esquema
   da seção 4), incluindo is_deuterocanonical e canon_order do cânon católico
   de 73 livros.
3. Grave os seeds em supabase/seed/bible/figueiredo/ (um JSON por livro) com
   source, source_ref, license, modernized e review_status.
4. Rode a validação da seção 5: confirme os 73 livros e a presença dos 7
   deuterocanônicos; gere relatório de cobertura e lista de itens sinalizados
   para revisão por amostragem.
5. Rode pnpm typecheck e pnpm lint.

NÃO escreva código ainda: primeiro me apresente o plano de arquivos e como vai
detectar/descartar os comentários, para eu aprovar. Depois execute em commits
pequenos.
```

---

## 8. Fase 2 (não fazer agora)
- **Bíblia moderna** (CNBB/Ave Maria) → licença com CNBB/Paulus/Editora Ave Maria.
- **Áudio da Bíblia** → narração própria do texto Figueiredo (já é livre) ou licenciada.
