# Fundação do Projeto — Meu Oratório (monorepo)

> Instrução executável para o Claude Code montar o ESQUELETO do projeto (monorepo
> web + mobile), onde a documentação de conteúdo e os design tokens vão encaixar.
> Meta: estrutura rodando + 1 tela visível (Início). Sem features completas ainda.
> Ler junto com `docs/mvp-conteudo-instrucoes.md` e `docs/decisoes-design.md`.

---

## 0. Decisões já tomadas (não reabrir)

- **Monorepo:** pnpm workspaces + Turborepo.
- **Mobile:** Expo (USAR O ÚLTIMO SDK ESTÁVEL — não o 52) + Expo Router + NativeWind + Reanimated.
- **Web:** Next.js (App Router) — **só a landing** agora; app-via-browser é Fase 3.
- **Backend:** Supabase (Postgres + Auth + Storage + Realtime + Edge Functions + pgvector).
- **Compartilhado:** lógica + design tokens (NÃO componentes visuais). NativeWind no mobile,
  Tailwind na web, ambos consumindo o MESMO preset de `packages/ui`.
- **Estado/dados:** Zustand + TanStack Query em `packages/core`.
- **Tema "santuário":** azul manto `#173A72` + ouro vela `#D2A94E` (ver `packages/ui/tokens.ts`).
- **Tipografia:** Schibsted Grotesk (display) + Hanken Grotesk (UI) + Literata (corpo de oração).
- **Tabs:** Início · Rezar · Descobrir · Comunidade · Perfil.
- **Liquid Glass:** real no iOS; fallback sólido translúcido no Android/web.

---

## 1. Estrutura alvo

```
meuoratorio/
├── apps/
│   ├── mobile/                 # Expo + Expo Router
│   │   ├── app/
│   │   │   ├── (tabs)/         # index(Início), pray, discover, community, profile
│   │   │   └── _layout.tsx     # carrega fontes + providers
│   │   ├── components/
│   │   └── tailwind.config.js  # preset de packages/ui
│   └── web/                    # Next.js (App Router) — landing
│       ├── app/page.tsx        # landing meuoratorio.com.br
│       └── tailwind.config.ts  # preset de packages/ui
├── packages/
│   ├── ui/                     # tokens.ts + tailwind-preset.js (JÁ EXISTEM) + componentes base
│   ├── core/                   # supabase client, types, stores (zustand), hooks (tanstack)
│   └── config/                 # tsconfig, eslint, prettier compartilhados
├── supabase/
│   ├── migrations/
│   ├── functions/prayer-guide/ # Edge Function (Deno) — Claude API server-side
│   └── seed/
├── package.json                # workspaces
├── pnpm-workspace.yaml
└── turbo.json
```

> Reaproveitar `packages/ui/tokens.ts` e `packages/ui/tailwind-preset.js` já criados.

---

## 2. Escopo desta fundação (e o que NÃO fazer)

**Fazer:**
- Monorepo configurado (pnpm + Turborepo) com os workspaces acima.
- `packages/ui`: além dos tokens, 2–3 componentes base (ex.: `GlassCard`, `Button`) com o
  fallback do Liquid Glass.
- `packages/core`: cliente Supabase tipado + providers (TanStack Query) + 1 store de exemplo.
- **mobile**: Expo Router com as 5 tabs e a tela **Início** renderizando no tema santuário,
  com as 3 fontes carregadas (Schibsted/Hanken via expo-google-fonts; Literata idem).
- **web**: Next com uma **landing** mínima no tema (hero + chamada), usando o mesmo preset.
- `supabase/`: init do projeto local + pasta de migrations/seed/functions vazias (estrutura).

**NÃO fazer agora:**
- Conteúdo (orações, Bíblia, santos) — isso são os outros docs de ingestão.
- Auth completo, pagamentos, comunidade, módulo de IA — só deixar a estrutura/flags.
- App-via-browser na web (Fase 3).

---

## 3. Cuidados técnicos

- **Expo SDK:** verificar e usar o último estável; alinhar Reanimated/Expo Router/AV.
- **Fontes no mobile:** carregar via `@expo-google-fonts/schibsted-grotesk`,
  `@expo-google-fonts/hanken-grotesk`, `@expo-google-fonts/literata` no `_layout.tsx` e mapear
  para `font-display` / `font-sans` / `font-prayer`.
- **Tokens compartilhados:** os dois apps importam `@meuoratorio/ui/tailwind-preset`.
- **Liquid Glass:** iOS usa blur real (ex.: expo-blur); Android/web caem no
  `surface.glass` (translúcido sólido) — sem blur custoso.
- **TypeScript estrito** e ESLint/Prettier de `packages/config` em todos os pacotes.
- Validar no fim: `pnpm install`, `pnpm typecheck`, `pnpm lint`, e o app mobile sobe a tela Início.

---

## 4. Prompt pronto para colar no Claude Code

> Cole no Claude Code em plan mode (Shift+Tab). Pré-requisito: a pasta já tem `docs/` e
> `packages/ui/tokens.ts` + `tailwind-preset.js`.

```
Leia docs/fundacao-projeto.md, docs/decisoes-design.md e
docs/mvp-conteudo-instrucoes.md, e os arquivos packages/ui/tokens.ts e
packages/ui/tailwind-preset.js.

Monte a FUNDAÇÃO do monorepo Meu Oratório seguindo À RISCA a instrução. NÃO
implemente conteúdo (orações/Bíblia/santos) nem features completas — só o
esqueleto rodando com 1 tela visível.

Faça:
1. Configure o monorepo: pnpm workspaces + Turborepo (package.json,
   pnpm-workspace.yaml, turbo.json) e packages/config (tsconfig, eslint,
   prettier compartilhados).
2. apps/mobile: Expo com o ÚLTIMO SDK estável (não o 52) + Expo Router +
   NativeWind + Reanimated. Crie as 5 tabs (Início, Rezar, Descobrir,
   Comunidade, Perfil) e a tela Início renderizando no tema santuário.
   Carregue Schibsted Grotesk, Hanken Grotesk e Literata via
   @expo-google-fonts e mapeie para font-display/font-sans/font-prayer.
3. apps/web: Next.js (App Router) com uma landing mínima no tema (hero +
   chamada), usando o mesmo tailwind-preset. NÃO crie o app-via-browser (Fase 3).
4. packages/ui: reaproveite tokens.ts e tailwind-preset.js; adicione GlassCard
   e Button com o fallback do Liquid Glass (blur no iOS, surface.glass no
   Android/web).
5. packages/core: cliente Supabase tipado + provider do TanStack Query + um
   store Zustand de exemplo.
6. supabase/: inicialize a estrutura (migrations/, seed/, functions/prayer-guide/)
   vazia, pronta para os próximos passos.
7. Valide: pnpm install, pnpm typecheck, pnpm lint, e confirme que o app mobile
   abre a tela Início no tema correto.

NÃO escreva código ainda: primeiro me apresente o plano de arquivos e as
versões (Expo SDK, Next, libs) que vai usar, para eu aprovar. Depois execute em
commits pequenos e descritivos.
```

---

## 5. Depois da fundação (ordem sugerida)
1. **Fundação** (este doc).
2. **Conteúdo MVP** (`mvp-conteudo-instrucoes.md`): schema + seeds das orações/terço/santos.
3. **Ingestão de orações de santos** (`ingestao-oracoes-santos.md`).
4. **Ingestão da Bíblia** (`ingestao-biblia.md`).
5. Auth, assinatura, módulo de IA, comunidade — por último.
