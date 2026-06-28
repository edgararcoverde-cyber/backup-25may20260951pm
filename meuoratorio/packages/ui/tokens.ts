/**
 * Design tokens — Meu Oratório
 * Tema "santuário". Compartilhado por web (Tailwind) e mobile (NativeWind).
 * Fonte das decisões: docs/decisoes-design.md (D1/D2) + briefing.
 *
 * Cores inegociáveis do briefing: azul manto #173A72 + ouro vela #D2A94E.
 * Os tons derivados abaixo são um ponto de partida — ajustar no teste de UI
 * sobre o fundo escuro antes de cravar.
 */

export const colors = {
  // Azul manto — cor primária
  mantle: {
    900: '#0E2549',
    800: '#173A72', // referência do briefing
    700: '#1F4A8F',
    DEFAULT: '#173A72',
  },
  // Ouro vela — acento (chama, destaques, CTAs sagrados)
  candle: {
    600: '#B8923D',
    500: '#D2A94E', // referência do briefing
    400: '#E0BE6E',
    DEFAULT: '#D2A94E',
  },
  // Superfícies do tema escuro
  surface: {
    base: '#0B1A33', // fundo profundo do app
    raised: '#12264A', // cartão / superfície elevada (base do Liquid Glass)
    glass: 'rgba(23, 58, 114, 0.55)', // fallback translúcido sem blur (Android/web)
  },
  // Texto (legibilidade no escuro)
  text: {
    primary: '#F4F1E8', // marfim quente
    muted: '#B9C2D0',
    onCandle: '#0E2549', // texto sobre o ouro
  },
} as const;

export const fontFamily = {
  // Grotesk (sem serifa) — interface, conforme briefing
  display: ['Schibsted Grotesk', 'system-ui', 'sans-serif'], // títulos / display
  body: ['Hanken Grotesk', 'system-ui', 'sans-serif'], // texto de UI
  // Serifada — corpo de oração / leitura devocional (D1/D2). Default: Literata.
  prayer: ['Literata', 'Georgia', 'serif'],
} as const;

export const fontSize = {
  xs: '12px',
  sm: '14px',
  base: '16px',
  lg: '18px',
  // Corpo de oração: maior e mais espaçado para leitura contemplativa
  prayer: ['20px', { lineHeight: '1.6' }],
  xl: '22px',
  '2xl': '28px',
  '3xl': '34px',
} as const;

export const radius = {
  sm: '8px',
  md: '14px',
  lg: '22px',
  pill: '999px',
} as const;

export const tokens = { colors, fontFamily, fontSize, radius } as const;
export default tokens;
