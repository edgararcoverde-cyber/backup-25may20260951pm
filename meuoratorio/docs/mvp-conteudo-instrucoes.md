# Instrução de Build — MVP de Conteúdo (Meu Oratório)

> Documento executável para o Claude Code construir a **camada de conteúdo do MVP** usando
> apenas fontes **livres de licença** (domínio público + calendário open-source).
> Objetivo: um app católico completo e **legalmente seguro**, sem depender de texto da CNBB.
>
> Ler junto com `docs/fontes-conteudo.md` (justificativa jurídica de cada escolha).

---

## 0. Princípio inegociável

**Só entra no MVP conteúdo 🟢 VERDE** (domínio público ou open-source). NADA de:
- texto da Liturgia Diária oficial da CNBB,
- Bíblia "Tradução Oficial da CNBB",
- scrapers de liturgia (Dancrf, JosueSantos, twistershark, LucasGiori, Canção Nova).

Liturgia oficial e Bíblia da CNBB ficam para a **Fase 2 (licenciada)**, atrás de uma feature flag.

---

## 1. Escopo do MVP de conteúdo

| Módulo | Conteúdo | Fonte | Licença |
|---|---|---|---|
| **Orações** | Pai-Nosso, Ave-Maria, Glória, Credo (Apostólico e Niceno), Salve-Rainha, Angelus, Atos de Fé/Esperança/Caridade, Ofereço-vos | Domínio público (Vatican.va pt) | 🟢 |
| **Terço / Rosário** | 4 conjuntos de mistérios (Gozosos, Luminosos, Dolorosos, Gloriosos) + como rezar | Domínio público | 🟢 |
| **Ladainhas** | Ladainha de Nossa Senhora (Lauretana), de Todos os Santos | Domínio público (Vatican.va) | 🟢 |
| **Devoções** | Coroa da Divina Misericórdia, Novena a N. Sra. Aparecida, Novena ao Sagrado Coração | Domínio público | 🟢 |
| **Santos** | Santos brasileiros + universais: bio curta + oração | Conteúdo editorial próprio | 🟢 |
| **Calendário litúrgico** | Tempo, cor, grau, santo do dia | litcal (Apache-2.0) auto-hospedado + calendário BR próprio | 🟢 |

> Bíblia, Liturgia Diária = **fora do MVP**. Deixar tabelas/flags preparadas, mas vazias.

---

## 2. Fontes técnicas (livres) e como conectar

### 2.1 Calendário litúrgico — litcal (auto-hospedado)
- Repo: `github.com/Liturgical-Calendar/LiturgicalCalendarAPI` (Apache-2.0).
- Saída: JSON/YAML/XML/ICS. Endpoints nacionais/diocesanos.
- **Tarefa:** auto-hospedar OU pré-gerar JSON anual e versionar em `supabase/seed/calendar/`.
- **Calendário BR:** criar `seed/calendar/brazil-particular.json` com as celebrações próprias do Brasil
  (ex.: 12/out N. Sra. Aparecida — padroeira; santos brasileiros) e **fundir** com o calendário romano.
- Alternativa embarcável: `romcal` (`npm i romcal`) para cálculo client-side.
- ⚠️ A lib só calcula datas/tempos. O **texto** das celebrações brasileiras é editorial próprio.

### 2.2 Orações tradicionais — texto de domínio público
- Referência de texto oficial em pt: **Vatican.va / Vatican News**.
- **Tarefa:** transcrever/normalizar para JSON estruturado em `supabase/seed/prayers/`.
  NÃO depender de fetch em runtime — o conteúdo é **embarcado** (seed), funciona offline.

### 2.3 O que NÃO conectar
- Nenhuma API de liturgia diária brasileira (todas são scraping de IP da CNBB).
- Nenhuma API bíblica (abibliadigital = traduções protestantes; Ave Maria JSON = sem licença).

---

## 3. Modelo de dados (Supabase / Postgres)

Criar migração com estas tabelas (ajustar ao schema já existente do projeto):

```sql
-- Categorias de conteúdo (orações, terço, novena, ladainha, devoção, santo)
create table content_categories (
  id text primary key,            -- 'prayer','rosary','novena','litany','devotion','saint'
  name text not null,
  icon text,
  sort_order int default 0
);

-- Orações e textos devocionais (todo conteúdo 🟢 livre)
create table prayers (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,            -- 'pai-nosso','ave-maria','coroa-divina-misericordia'
  title text not null,
  category_id text references content_categories(id),
  body_md text not null,                -- texto da oração em markdown
  source text,                          -- 'dominio-publico' | 'vatican.va' | 'editorial-proprio'
  license text not null default 'public-domain',
  language text not null default 'pt-BR',
  audio_url text,                       -- narração própria (Fase de áudio); null no início
  is_premium boolean default false,
  created_at timestamptz default now()
);

-- Mistérios do rosário (4 conjuntos x 5 mistérios)
create table rosary_mysteries (
  id uuid primary key default gen_random_uuid(),
  set_name text not null,               -- 'gozosos','luminosos','dolorosos','gloriosos'
  weekday int,                          -- dia sugerido (0-6)
  position int not null,                -- 1..5
  title text not null,
  meditation_md text,
  fruit text                            -- 'fruto do mistério'
);

-- Santos (editorial próprio)
create table saints (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  feast_month int,                      -- mês da festa
  feast_day int,                        -- dia da festa
  is_brazilian boolean default false,
  patronage text,                       -- 'padroeira do Brasil', etc.
  bio_md text not null,
  prayer_id uuid references prayers(id),
  image_url text
);

-- Calendário litúrgico (gerado por litcal + fusão BR)
create table liturgical_calendar (
  date date primary key,
  season text,                          -- 'advento','natal','quaresma','pascoa','comum'
  color text,                           -- 'verde','roxo','branco','vermelho','rosa'
  celebration text,                     -- nome da celebração do dia
  grade text,                           -- 'solenidade','festa','memoria','feria'
  saint_id uuid references saints(id),
  is_brazilian_proper boolean default false
);

-- Flags para conteúdo licenciado da Fase 2 (vazio no MVP)
create table licensed_content_flags (
  feature text primary key,             -- 'daily_liturgy','cnbb_bible'
  enabled boolean default false,
  license_holder text,                  -- 'CNBB','Editora Ave Maria'
  notes text
);
```

RLS: leitura pública para conteúdo `is_premium = false`; conteúdo premium exige assinatura ativa
(reaproveitar a checagem de entitlement do RevenueCat/Stripe definida no briefing).

---

## 4. Estrutura de seed

```
supabase/seed/
├── prayers/
│   ├── tradicionais.json        # Pai-Nosso, Ave-Maria, Credo, Salve-Rainha, Angelus, atos
│   ├── divina-misericordia.json # Coroa da Divina Misericórdia
│   └── novenas.json             # Aparecida, Sagrado Coração
├── rosary/
│   └── misterios.json           # 4 conjuntos x 5 mistérios
├── litanies/
│   └── lauretana.json           # Ladainha de N. Senhora
├── saints/
│   └── santos-brasil.json       # santos brasileiros + universais (bio + oração)
├── calendar/
│   ├── roman-2026.json          # gerado por litcal
│   └── brazil-particular.json   # celebrações próprias do Brasil (manual)
└── README.md                    # proveniência + licença de cada arquivo
```

Cada item do seed DEVE carregar `source` e `license` (rastreabilidade jurídica).

Exemplo (`prayers/tradicionais.json`):
```json
[
  {
    "slug": "pai-nosso",
    "title": "Pai-Nosso",
    "category_id": "prayer",
    "source": "dominio-publico",
    "license": "public-domain",
    "language": "pt-BR",
    "body_md": "Pai nosso que estais nos céus, santificado seja o vosso nome..."
  }
]
```

---

## 5. Passos de execução (ordem)

1. **Migração** `supabase/migrations/xxxx_content_schema.sql` com as tabelas da seção 3 + RLS.
2. **Seed de orações tradicionais** (`prayers/tradicionais.json`) — começar pelas 10 orações essenciais.
3. **Seed do terço** (mistérios) + tela "Como rezar o terço".
4. **Seed de ladainha + Divina Misericórdia + 1 novena** (Aparecida).
5. **Seed de santos** — 5 brasileiros para começar (ex.: Frei Galvão, Madre Paulina, Irmã Dulce, José de Anchieta, N. Sra. Aparecida).
6. **Calendário:** script `scripts/build-calendar.ts` que gera `roman-{ano}.json` via litcal/romcal e funde `brazil-particular.json` → popula `liturgical_calendar`.
7. **Hooks de leitura** (TanStack Query) em `packages/core`: `usePrayers`, `useRosary`, `useSaintOfDay`, `useTodayLiturgy`.
8. **Telas** (reproduzir protótipos): Rezar (lista de orações/terço/novenas), Descobrir (santos + calendário), detalhe de oração com player de áudio (placeholder até gravar áudio).
9. **Feature flags:** `licensed_content_flags` com `daily_liturgy` e `cnbb_bible` = `false`.
10. **Verificação:** `pnpm typecheck && pnpm lint`; conferir que todo seed tem `license`; rodar app e abrir uma oração, o terço e o santo do dia.

---

## 6. Regras de qualidade

- **Rastreabilidade:** todo conteúdo no banco tem `source` + `license`. Nenhum item sem proveniência.
- **Offline-first:** orações/terço/santos vêm do seed embarcado (funciona sem rede). Calendário pode pré-gerar 2 anos.
- **Revisão doutrinária:** marcar no README do seed que o conteúdo deve passar por **revisão de um sacerdote** antes do lançamento.
- **Sem scraping:** nenhuma chamada a APIs de liturgia de terceiros em runtime.
- **i18n pronto:** campo `language` em tudo, mesmo que só pt-BR agora.

---

## 7. Prompt pronto para colar no Claude Code

> Copie e cole no Claude Code (de preferência em **plan mode** — `Shift+Tab` — para revisar antes de executar):

```
Leia docs/fontes-conteudo.md e docs/mvp-conteudo-instrucoes.md.

Implemente a camada de conteúdo do MVP seguindo À RISCA a instrução, usando
APENAS conteúdo livre de licença (domínio público + calendário open-source).
NÃO use texto da Liturgia Diária oficial da CNBB, NÃO use a Bíblia da CNBB e
NÃO use nenhum scraper de liturgia (Dancrf, JosueSantos, twistershark,
LucasGiori, Canção Nova) — esses ficam para a Fase 2 atrás de feature flag.

Execute nesta ordem:
1. Crie a migração supabase/migrations com as tabelas e RLS da seção 3
   (content_categories, prayers, rosary_mysteries, saints, liturgical_calendar,
   licensed_content_flags).
2. Crie a estrutura de seed da seção 4, com source + license em cada item.
   Comece pelas 10 orações tradicionais essenciais, os 20 mistérios do terço,
   a Ladainha Lauretana, a Coroa da Divina Misericórdia, a Novena de Aparecida
   e 5 santos brasileiros (Frei Galvão, Madre Paulina, Irmã Dulce,
   José de Anchieta, N. Sra. Aparecida).
3. Crie scripts/build-calendar.ts que gera o calendário romano via romcal e
   funde brazil-particular.json, populando liturgical_calendar.
4. Crie os hooks em packages/core (usePrayers, useRosary, useSaintOfDay,
   useTodayLiturgy) e as telas Rezar e Descobrir reproduzindo os protótipos.
5. Deixe licensed_content_flags com daily_liturgy e cnbb_bible = false.
6. Rode pnpm typecheck e pnpm lint; garanta que todo item de seed tem o campo
   license; confirme que dá pra abrir uma oração, o terço e o santo do dia.

NÃO escreva código ainda: primeiro me apresente o plano de arquivos que vai
criar/alterar para eu aprovar. Depois de aprovado, execute e faça commits
pequenos e descritivos por etapa.
```

---

## 8. Fase 2 (licenciada) — não fazer agora

- Negociar licença com **Edições CNBB / CNBB** (Liturgia Diária, Bíblia oficial) e/ou **Editora Ave Maria**.
- Ao obter licença: ligar `licensed_content_flags`, popular tabelas de liturgia/Bíblia, liberar nas telas.
- Áudio: produzir **narração própria** do conteúdo livre (diferencial frente ao Hallow no Brasil).
