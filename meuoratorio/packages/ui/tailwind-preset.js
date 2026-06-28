/**
 * Tailwind preset — Meu Oratório
 * Importado tanto pelo web (Tailwind, apps/web) quanto pelo mobile
 * (NativeWind, apps/mobile), para os dois compartilharem os MESMOS tokens.
 *
 * Uso (tailwind.config.js de cada app):
 *   module.exports = { presets: [require('@meuoratorio/ui/tailwind-preset')], ... }
 *
 * Os valores espelham packages/ui/tokens.ts. (JS puro aqui para o Tailwind
 * consumir sem passo de build; manter os dois em sincronia.)
 */

const colors = {
  mantle: {
    900: '#0E2549',
    800: '#173A72',
    700: '#1F4A8F',
    DEFAULT: '#173A72',
  },
  candle: {
    600: '#B8923D',
    500: '#D2A94E',
    400: '#E0BE6E',
    DEFAULT: '#D2A94E',
  },
  surface: {
    base: '#0B1A33',
    raised: '#12264A',
  },
  ink: {
    DEFAULT: '#F4F1E8',
    muted: '#B9C2D0',
  },
};

/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      colors,
      fontFamily: {
        // Grotesk (sem serifa) — UI
        display: ['Schibsted Grotesk', 'system-ui', 'sans-serif'],
        sans: ['Hanken Grotesk', 'system-ui', 'sans-serif'],
        // Serifada — corpo de oração (D1/D2)
        prayer: ['Literata', 'Georgia', 'serif'],
      },
      fontSize: {
        prayer: ['20px', { lineHeight: '1.6' }],
      },
      borderRadius: {
        pill: '999px',
      },
    },
  },
};

/*
 * NOTA (mobile / NativeWind):
 * No React Native as fontes precisam ser carregadas e referenciadas pelo nome
 * do arquivo da fonte (ex.: 'SchibstedGrotesk_400Regular' via expo-font /
 * @expo-google-fonts). Carregue Schibsted Grotesk, Hanken Grotesk e Literata
 * (todas no Google Fonts / OFL) no _layout e mapeie esses nomes para as
 * classes font-display / font-sans / font-prayer.
 */
