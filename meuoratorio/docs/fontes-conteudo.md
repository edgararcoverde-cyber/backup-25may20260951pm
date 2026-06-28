# Fontes de Conteúdo — Meu Oratório

> Pesquisa de fontes para alimentar o app com liturgia, orações, santos e Bíblia em pt-BR.
> Foco em: o que é **conectável** (API/feed) vs. **scraping**, e a **situação de direitos autorais** para uso comercial num app freemium pago.
>
> **Status:** pesquisa verificada de forma adversarial (24 de 25 alegações confirmadas).
> **Aviso:** este documento identifica fontes e status de copyright; **não é aconselhamento jurídico**. Qualquer uso comercial de texto litúrgico/bíblico exige confirmação contratual direta com o detentor dos direitos.

---

## TL;DR — a divisão que importa

Não existe uma fonte única, oficial e licenciável que se "plugue e pronto". O conteúdo de maior valor (liturgia diária oficial, Bíblia da CNBB) é **propriedade intelectual da CNBB/editoras** e exige **licença formal** para um app pago. O que é livre é o **calendário litúrgico** (infraestrutura de cálculo) e as **orações tradicionais de domínio público**.

| Categoria | Status jurídico | Estratégia |
|---|---|---|
| Calendário litúrgico (cálculo) | 🟢 Livre (open-source) | Auto-hospedar + adicionar calendário BR manualmente |
| Orações tradicionais (terço, novenas, ladainhas, Divina Misericórdia) | 🟢 Domínio público | Embarcar direto — coração gratuito do app |
| Santos (biografias/orações) | 🟢 Curar/escrever próprio | Conteúdo editorial próprio |
| Bíblia "Ave Maria" (JSON) | 🟡 Existe, sem licença clara | Confirmar com a editora antes de uso comercial |
| Liturgia Diária oficial ("Igreja em Oração") | 🔴 IP da CNBB | Licença formal (Fase 2) |
| Bíblia "Tradução Oficial da CNBB" | 🔴 IP da CNBB / Paulus | Licença formal (Fase 2) |
| Áudio católico licenciável | 🔴 Não existe pronto | Produzir narração própria |

---

## 🟢 VERDE — usar livremente

### Calendário litúrgico (infraestrutura de cálculo)

Calculam tempos litúrgicos, festas móveis (Páscoa, etc.), cores e graus de celebração. **Licença open-source clara**, dados em formatos conectáveis.

| Projeto | Licença | Formato | Observação |
|---|---|---|---|
| **litcal** (`LiturgicalCalendarAPI`) | Apache-2.0 | JSON / YAML / XML / ICS | Melhor aposta. Endpoints nacionais (`/calendar/nation/{NATION}`) e diocesanos (`/calendar/diocese/{DIOCESE}`). Auto-hospedável. |
| **calapi.inadiutorium.cz** (Church Calendar API) | LGPL-3 (código) | JSON REST read-only | Não suporta pt — locales: en, la, fr, it, cs. |
| **romcal** | open-source | Lib JS/TS (`npm i romcal`) | Embarcável no app. Forma Ordinária + calendários nacionais via plugins. |

- **Fontes:** github.com/Liturgical-Calendar/LiturgicalCalendarAPI · calapi.inadiutorium.cz · github.com/calendarium-romanum/awesome-church-calendar
- ⚠️ **Atenção crítica:** NENHUMA traz o **calendário particular do Brasil (CNBB)** pronto, nem locale pt-BR. Será preciso **auto-hospedar** e **adicionar o calendário brasileiro à mão** (padroeira N. Sra. Aparecida 12/out, santos brasileiros, solenidades locais).
- ✅ A licença open-source cobre o **código**; o calendário gerado é cálculo de datas (fatos), não texto protegido.

### Orações tradicionais (domínio público)

Pai-Nosso, Ave-Maria, Glória, Credo, Salve-Rainha, terço/rosário (mistérios), ladainhas (Lauretana), Divina Misericórdia, Angelus, atos de fé/esperança/caridade, etc.

- **Texto oficial em português** disponível no **Vatican.va** e **Vatican News** (ex.: `vatican.va/special/rosary/documents/litanie-lauretane_po.html`, mistérios do rosário).
- Formato: HTML — extrair e **normalizar** para o seu schema.
- ✅ Orações tradicionais e a Coroa da Divina Misericórdia são domínio público. O risco jurídico é mínimo. **Esta é a base gratuita do app.**

### Santos brasileiros

- Não há "API de santos brasileiros" licenciável pronta.
- **Estratégia:** curar/escrever as biografias e orações como **conteúdo editorial próprio** (devocional, baseado em fatos públicos). Isso vira diferencial do app e evita dependência de terceiros.
- Datas dos santos brasileiros entram no **calendário BR manual** (ver acima).

---

## 🟡 AMARELO — existe, mas confirmar antes

### Bíblia católica "Ave Maria" em JSON

- **Fonte:** `github.com/fidalgobr/bibliaAveMariaJSON` — 73 livros (com deuterocanônicos), pronto para importar.
- ⚠️ O repositório **não tem licença nem aviso de copyright**. Silêncio jurídico **não** é permissão. A tradução "Ave Maria" pertence à Editora Ave Maria.
- **Conclusão:** ótimo para protótipo/teste; para uso comercial, **licenciar com a Editora Ave Maria** ou trocar por fonte licenciada.

### Bíblia "Ave Maria" + Áudio (precedente)

- Existe app iOS "Bíblia Ave Maria + Áudio Mp3" (App Store ID 1602343615) com AT+NT em texto e MP3.
- Prova que **Bíblia católica em áudio é viável** — mas via **licença com a editora**, não gratuito.

---

## 🔴 VERMELHO — exige licença formal (não usar sem contrato)

### Liturgia Diária oficial — "Igreja em Oração" (Edições CNBB)

- Editora oficial: **Edições CNBB**. Produto pago (~US$0,99/edição ou assinatura anual via PIX/cartão).
- **NÃO há API/feed oficial.** Os termos da loja proíbem reuso de textos/layout.
- Distribuição é **produto ao consumidor** (app/impresso), não licenciamento B2B público — provável **negociação direta**.
- Fontes: edicoescnbb.com.br/liturgia-e-assinaturas · cnbb.org.br/liturgia-diaria-app

### Bíblia "Tradução Oficial da CNBB"

- Texto proprietário da **CNBB**, vendido pela **Paulus** (loja.paulus.com.br). Traduzida do hebraico/aramaico/grego com a Nova Vulgata como guia.
- Uso num app pago exige **licença formal**. Não é domínio público.

### Scrapers de liturgia (NÃO usar em produção comercial)

Vários projetos "conectáveis" em JSON, mas que **fazem scraping** do site da CNBB / Canção Nova / sagradaliturgia.com.br. O texto continua sendo IP da CNBB.

| Projeto | O que faz | Por que evitar |
|---|---|---|
| `Dancrf/liturgia-diaria` | JSON em `liturgia.up.railway.app/v2/` | Sem licença; fonte não documentada; v1 com desativação marcada |
| `JosueSantos/api_liturgia_diaria` | JSON por data + santo-do-dia | Scraping de sagradaliturgia.com.br + Canção Nova; `license=null` |
| `twistershark/liturgia_diaria-scraping` | Loop na URL da CNBB | Scraping direto do site da CNBB |
| `LucasGiori/API-Liturgia-CNBB` | "Web Scraping das liturgias do site da CNBB" | Assume o scraping explicitamente |

- **Canção Nova** (`liturgia.cancaonova.com/pb/`) tem leituras + reflexão + homilia em **texto, áudio e vídeo**, e há endpoint JSON (`/pb/json/`). É serviço de terceiro e **não resolve o copyright do texto litúrgico** subjacente.
- ✅ Úteis como **referência/estudo**; ❌ inadequados para um produto pago.

---

## Ressalvas da pesquisa

- Vários sites oficiais (CNBB, Edições CNBB, Canção Nova, calapi) **bloquearam acesso automatizado (403)**; os fatos foram confirmados por fontes cruzadas, mas **confirme preços e canal de licenciamento direto com a CNBB**.
- Licenças open-source (Apache/LGPL/BSD) cobrem o **código** das APIs, **nunca o texto** litúrgico/bíblico servido. São camadas separadas.
- Sensibilidade temporal: preço de "Igreja em Oração" pode ter mudado; `Dancrf` v1 marcada para desativação.

## Perguntas em aberto (para resolver na Fase 2)

1. Processo e custo de **licença comercial** da CNBB/Edições CNBB para Liturgia Diária e Bíblia oficial — existe canal B2B/API empresarial?
2. A Bíblia "Ave Maria" ou traduções católicas antigas (ex.: Matos Soares) já estão em **domínio público** em pt?
3. Fonte de **áudio** da Bíblia católica pt-BR com licenciamento claro?

---

## Fontes citadas

- github.com/Liturgical-Calendar/LiturgicalCalendarAPI
- calapi.inadiutorium.cz
- github.com/calendarium-romanum/awesome-church-calendar
- github.com/fidalgobr/bibliaAveMariaJSON
- github.com/Dancrf/liturgia-diaria · github.com/JosueSantos/api_liturgia_diaria · github.com/twistershark/liturgia_diaria-scraping · github.com/LucasGiori/API-Liturgia-CNBB
- liturgia.cancaonova.com/pb
- edicoescnbb.com.br/liturgia-e-assinaturas · cnbb.org.br/liturgia-diaria-app
- loja.paulus.com.br/biblia-sagrada-traducao-oficial-da-cnbb
- abibliadigital.com.br
- vatican.va (orações tradicionais em pt)
