# Ingestão de Orações de Santos — Meu Oratório

> Instrução executável para o Claude Code montar o corpus de orações a santos em pt-BR
> usando fontes de **domínio público** + geração curada da cauda longa.
> Princípio: cobrir a MAIOR PARTE DO USO REAL (dezenas de santos populares) com texto livre,
> e o restante por molde editorial com revisão. Ler junto com `docs/fontes-conteudo.md`.

---

## 0. Realidade e meta

- Impossível ter oração PD para os ~10.000 santos. Desnecessário: a devoção concentra-se em
  algumas dezenas de santos populares — e ESSES estão nos devocionários antigos.
- **Meta:** 80–90% do uso coberto por domínio público; cauda longa por molde + revisão.
- ❌ NUNCA usar a "Oração Coleta" do Missal (copyright CNBB). ✅ Usar orações devocionais antigas (PD).
- Regra de PD no Brasil: autor morto há **70+ anos**. Obras séc. XVIII/XIX = PD garantido.

---

## 1. Fontes (com identificadores)

| # | Fonte | Conteúdo | Acesso | Licença |
|---|---|---|---|---|
| F1 | Internet Archive — "Formulario de orações e devoções" (Fr. Sarmento) | Devocionário clássico pt | id `DELTA53587_2FA` (scan+OCR) | PD |
| F2 | Devocionário PDF (resurrectionist.eu) | Novenas (1º–8º dia), orações a Maria/São José, ladainhas | `resurrectionist.eu/assets/Spirituality/ReadingRoom/in-Portoghese/Devocionario.pdf` | PD (confirmar autor/ano) |
| F3 | pt.wikisource.org | Orações marianas e a santos, estruturado | **MediaWiki API** | PD/CC |
| F4 | Alexandria Católica (blog) | Manuais de orações antigos p/ download | `alexandriacatolica.blogspot.com` | Maioria PD |
| F5 | Opus Dei — "Orações" (PDF, 108p) | Orações comuns, Maria, São José | `multimedia.opusdei.org/pdf/pt/oracoes.pdf` | CC (atribuição — checar) |

❌ Evitar: "Novenário"/Minha Biblioteca Católica e publicações recentes (copyright). Só referência.

---

## 2. Pipeline de ingestão (ordem)

### Etapa A — Obras de domínio público (F1, F2, F4)
1. Baixar os PDFs/scans para `data/raw/oracoes/`.
2. OCR quando necessário (`pdftotext`; se for imagem, `tesseract -l por`).
3. Parsear em itens: para cada oração/novena, extrair `{ santo, titulo, corpo, fonte, ano }`.
4. Normalizar ortografia antiga → pt-BR atual (preservar sentido; NÃO alterar doutrina).
5. Gravar em `supabase/seed/prayers/santos-dominio-publico.json`.

### Etapa B — Wikisource via API (F3) — única fonte estruturada
- Usar a MediaWiki API (sem scraping de HTML):
  - Listar categorias: `https://pt.wikisource.org/w/api.php?action=query&list=categorymembers&cmtitle=Categoria:Orações&cmlimit=500&format=json`
  - Conteúdo de uma página (wikitext): `...&action=parse&page=TITULO&prop=wikitext&format=json`
- Filtrar páginas de orações/novenas a santos; converter wikitext → markdown limpo.
- Gravar em `supabase/seed/prayers/santos-wikisource.json` (com `source: wikisource`, url e licença).

### Etapa C — Cauda longa (santos sem oração PD)
- Para cada santo do calendário sem oração nas etapas A/B, gerar com o **molde** (seção 3),
  a partir de bio de domínio público (Catholic Encyclopedia 1913 / Butler's).
- Marcar `license: editorial-proprio` e `review_status: pending`.
- Gravar em `supabase/seed/prayers/santos-gerados.json`.

---

## 3. Molde de oração de intercessão (estrutura livre — pt-BR)

> A ESTRUTURA não é protegida; só o texto específico do Missal é. Use este molde para a cauda longa.

```
Ó Deus, que destes a {Santo(a) NOME} a graça de {virtude/missão em poucas palavras},
concedei-nos, por sua intercessão, {graça/pedido}.
Que, seguindo o seu exemplo de {qualidade}, sejamos fiéis a Vós
em todos os momentos da nossa vida.
Por Cristo, nosso Senhor. Amém.

{Santo(a) NOME}, rogai por nós.
```

Variáveis vêm da bio PD. Saída sempre marcada para revisão (campo `review_status`).

---

## 4. Esquema de cada item de seed

```json
{
  "slug": "santo-antonio-de-padua",
  "saint_name": "Santo Antônio de Pádua",
  "title": "Oração a Santo Antônio",
  "category_id": "saint",
  "body_md": "...",
  "source": "dominio-publico",          // | "wikisource" | "editorial-proprio"
  "source_ref": "Formulario de orações (Sarmento), archive.org/DELTA53587_2FA",
  "license": "public-domain",            // | "cc-by" | "editorial-proprio"
  "language": "pt-BR",
  "review_status": "approved",           // gerados começam "pending"
  "audio_url": null
}
```

---

## 5. Regras de qualidade

- **Rastreabilidade obrigatória:** todo item tem `source`, `source_ref` e `license`. Sem isso, não entra.
- **Revisão doutrinária:** itens `editorial-proprio` ficam `pending` até aprovação de um sacerdote.
  No app, exibir apenas `review_status = approved`.
- **Sem Missal/CNBB:** nenhuma Oração Coleta litúrgica. Apenas devocionais PD ou geradas.
- **Confirmar PD:** para F2/F4/F5, registrar autor + ano; se não for possível confirmar PD, NÃO embarcar.
- **Atribuição CC:** se usar F5 (Opus Dei/CC), respeitar a atribuição exigida pela licença.
- **Offline-first:** corpus final embarcado como seed (funciona sem rede).

---

## 6. Prompt pronto para colar no Claude Code

> Cole no Claude Code, de preferência em plan mode (Shift+Tab).

```
Leia docs/fontes-conteudo.md, docs/mvp-conteudo-instrucoes.md e
docs/ingestao-oracoes-santos.md.

Implemente o pipeline de ingestão de orações a santos seguindo À RISCA a
instrução. Use APENAS conteúdo de domínio público (F1, F2, F4), Wikisource via
API (F3) e geração curada para a cauda longa. NÃO use a Oração Coleta do Missal
nem qualquer texto da CNBB; NÃO use fontes modernas protegidas (ex.: Novenário).

Execute nesta ordem:
1. Crie a estrutura data/raw/oracoes/ e scripts/ingest/ com:
   a) scripts/ingest/parse-pdf.ts — extrai orações/novenas de PDFs PD
      (pdftotext; tesseract -l por quando for imagem) para JSON normalizado.
   b) scripts/ingest/wikisource.ts — consome a MediaWiki API do pt.wikisource
      (action=query/categorymembers + action=parse/wikitext), filtra orações a
      santos e converte para markdown limpo.
   c) scripts/ingest/gen-longtail.ts — para santos do calendário sem oração PD,
      gera a oração pelo molde da seção 3 a partir de bio de domínio público,
      marcando review_status="pending".
2. Grave os seeds em supabase/seed/prayers/ (santos-dominio-publico.json,
   santos-wikisource.json, santos-gerados.json), cada item com source,
   source_ref, license, language e review_status (esquema da seção 4).
3. Garanta que o app exiba apenas review_status="approved".
4. Rode pnpm typecheck e pnpm lint; valide que TODO item tem source + license;
   gere um relatório de cobertura (quantos santos do calendário têm oração e
   de qual fonte).

NÃO escreva código ainda: primeiro me apresente o plano de arquivos e o
desenho dos scripts para eu aprovar. Depois execute em commits pequenos.
```

---

## 7. Expectativa de cobertura

- Etapas A+B → dezenas de santos populares (cobre a maior parte do USO).
- Etapa C → preenche a cauda longa do calendário, com revisão.
- Relatório de cobertura (passo 4) mostra exatamente o que ficou de fora para curadoria manual.
