# Decisões de Design — Meu Oratório

> Registro de decisões de design para não se perderem entre sessões.
> Base inegociável do briefing: tema escuro "santuário" (azul manto `#173A72` + ouro vela
> `#D2A94E`), símbolo da chama, Liquid Glass em superfícies elevadas.

---

## D1 — Tipografia: grotesk puro vs. híbrido com serifada nas orações

### Contexto
O briefing define **Schibsted Grotesk** (títulos/display) + **Hanken Grotesk** (texto) —
ambas **sem serifa** (grotesk = sans-serif). Visual moderno e limpo.

Surgiu a questão: o **corpo das orações** (textos longos, devocionais) fica melhor numa
fonte **serifada**? Muitos apps devocionais usam serifada no corpo da oração — passa um tom
tradicional, "de missal", e é confortável para leitura longa.

### Opções
1. **Grotesk puro** — tudo em Schibsted/Hanken. Coerência total com o briefing; estética app moderno.
2. **Híbrido (recomendado)** — interface (navegação, botões, títulos, listas) em
   Schibsted/Hanken Grotesk; **corpo das orações em fonte serifada**. Dá reverência e
   legibilidade aos textos longos, mantendo a identidade moderna no restante.

### Decisão
**Adotar o híbrido**, com a serifada **restrita ao corpo de leitura devocional** (oração,
novena, salmo, meditação). Tudo o mais permanece grotesk, conforme o briefing.

> Status: proposta — confirmar com o autor (Edgar). Reversível: é um token de tipografia.

### Regras de aplicação
- **Display/UI:** Schibsted Grotesk.
- **Texto de UI:** Hanken Grotesk.
- **Corpo de oração (leitura):** fonte serifada (ver D2).
- Definir como **design tokens** em `packages/ui` (ex.: `font.display`, `font.body`,
  `font.prayer`) para web (Tailwind) e mobile (NativeWind) compartilharem a mesma decisão.

---

## D2 — Escolha da fonte serifada (corpo de oração)

Critérios: legível em **tema escuro** (sem hairlines finas demais que somem no fundo),
licença **aberta** (OFL/Google Fonts — funciona em Expo via `expo-font` e na web via
`next/font`), e par harmônico com as grotescas.

### Recomendadas (open-source / Google Fonts)
| Fonte | Caráter | Por que combina |
|---|---|---|
| **Literata** | Serifada de livro, desenhada para leitura em tela | Excelente em dark mode, peso consistente; leitura longa confortável. **1ª escolha.** |
| **Spectral** | Elegante, contemporânea, criada para tela | Ótimo contraste em fundo escuro; ar sóbrio e reverente. |
| **Lora** | Levemente caligráfica, quente | Tom devocional acolhedor; muito usada em conteúdo de leitura. |
| **Cardo / EB Garamond** | Clássica, "de missal" | Máxima tradição litúrgica. ⚠️ Hairlines finas — testar bem no fundo escuro; pode pedir peso/medium. |

### Recomendação
**Literata** como corpo de oração (robusta no escuro, leitura longa) — ou **Spectral**, se
quiser um ar mais formal/litúrgico. Cardo/EB Garamond só se o teste no tema `#173A72`
provar que a fineza dos traços não prejudica a leitura.

### Notas técnicas
- Usar fontes **OFL/Google Fonts** evita custo e libera uso comercial no app freemium.
- Embarcar as fontes (offline-first): `expo-font` no mobile, `next/font/google` (ou self-host) na web.
- Tamanho/entrelinha do corpo de oração mais generosos (ex.: 18–20px, leading ~1.6) para leitura contemplativa.
- Testar legibilidade real sobre o azul manto `#173A72` e em superfícies Liquid Glass antes de cravar.

---

## D3 — Liquid Glass: fallback fora do iOS (registrado)
Blur pesado degrada performance no Android/web e renderiza diferente. **Decisão:** Liquid
Glass real no iOS; **fallback** de superfície sólida levemente translúcida (sem blur custoso)
em Android/web. (Ver também `mvp-conteudo-instrucoes.md`.)

---

## Pendências de design a confirmar com o autor
- [ ] Confirmar D1 (híbrido) e D2 (fonte serifada: Literata vs. Spectral).
- [ ] Definir tokens de tipografia em `packages/ui`.
- [ ] Teste de legibilidade da serifada no tema escuro + Liquid Glass.
