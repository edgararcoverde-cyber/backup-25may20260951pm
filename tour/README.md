# Tour Imersivo — Apartamento Edgar & Tales

Experiência web para "caminhar" pelo apartamento a partir do render 3D.

## O que tem aqui (Fase 1)

- **`index.html`** — site do tour. Mostra o vídeo imersivo (movimento fluido, ritmo
  de caminhada) e deixa clicar em cada ambiente para pular direto a ele. Funciona em
  qualquer navegador, no PC e no celular.
- **`Tour_Imersivo_Fluido.mp4`** — vídeo do tour reprocessado a 60fps com interpolação
  de movimento (caminhada suave, sem cortes secos).

## Como abrir

1. Baixe a pasta `tour/` inteira (precisa do `index.html` **e** do `.mp4` juntos).
2. Dê dois cliques no `index.html` — abre no navegador. Pronto.

## Como publicar um link (grátis)

Qualquer uma destas opções hospeda de graça:

- **GitHub Pages**: ative Pages no repositório apontando para esta pasta → vira um link
  `https://<usuario>.github.io/<repo>/tour/`.
- **Netlify Drop**: arraste a pasta `tour/` em https://app.netlify.com/drop → gera um link na hora.
- **Cloudflare Pages / Vercel**: mesma ideia, arrastar/subir a pasta.

> Os capítulos por ambiente estão em `index.html` (lista `chapters`), com os tempos já
> ajustados para a velocidade do vídeo fluido. Se o vídeo for trocado, reveja os tempos.

## Fase 2 (opcional) — Tour 360° navegável

Para o "girar a visão livremente" em cada cômodo, é preciso gerar **panoramas 360°**.
Como o material original é só um vídeo (sem o arquivo 3D), o caminho 100% gratuito é
reconstruir cada ambiente com **Gaussian Splatting** usando a **GPU grátis do Google
Colab**, e depois montar os panoramas num tour navegável (Marzipano).

Roteiro do tour (13 pontos) e instruções do Colab serão adicionados nesta fase.
