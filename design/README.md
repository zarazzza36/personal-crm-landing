# Handoff: лендинг «Волки с Лизюкова» — личная CRM для логистов

## Overview
Одностраничный статичный лендинг. Единственное целевое действие — кнопка **«Перейти в приложение»** (3 места на странице, все ведут на один URL). Блоки по порядку: Hero → Проблема → Решение → Выгода → Призыв к действию → мини-футер.

## About the Design Files
Файлы в `design/` — **дизайн-референсы в HTML**, а не продакшн-код. Задача — воссоздать их в **Astro + Tailwind CSS 4** как статичную страницу. Открыть референсы: `design/Landing Mobile.dc.html` и `design/Landing Desktop.dc.html` в браузере (рядом должен лежать `support.js`). Все стили в них инлайновые — значения можно брать прямо из разметки.

- Мобильная версия: `Landing Mobile.dc.html` (ширина 390px)
- Десктоп: `Landing Desktop.dc.html` (рассчитан на ≥1200px, контент max-width 1280px)
- Исходный текст: `design/landing-text.md`

## Fidelity
**High-fidelity.** Цвета, шрифты, размеры, отступы финальные. Верстать пиксель-в-пиксель.

## Stack / структура (рекомендация)
```
src/
  layouts/Base.astro          — <html lang="ru">, шрифты, meta
  pages/index.astro           — сборка секций
  components/
    Header.astro
    Hero.astro
    Problem.astro
    Solution.astro
    Benefits.astro
    Cta.astro
    Footer.astro
    CtaButton.astro           — props: size ("md" | "lg"), variant ("solid" | "outline")
    Road.astro                — props: orientation ("vertical" | "horizontal"), slot для машин
    Truck.astro               — props: orientation, scale
    Car.astro                 — props: orientation, scale
  styles/global.css           — @import "tailwindcss"; @theme { … }
```
URL приложения вынести в одну константу (`src/config.ts` → `APP_URL`), сейчас в макете `href="#"`. **Нужно получить у заказчика.**

## Responsive
- `< lg` (до 1023px) — мобильная раскладка. Макет на 390px; на 391–1023 держать колонку `max-w-[560px] mx-auto`, фон с сеткой — на всю ширину.
- `≥ lg` (1024+) — десктопная раскладка, контейнер `max-w-[1280px] mx-auto px-12`. Макет нарисован на 1440; на 1024–1199 допустимо уменьшить h1 до ~48px.
- Иллюстрации дорог — `overflow-hidden` у родителя, обрезаются краями.

## Design Tokens (Tailwind 4 `@theme`)
```css
@import "tailwindcss";
@theme {
  --color-ink: #161719;          /* фон страницы, тёмный текст на светлом */
  --color-paper: #f2f0ea;        /* основной светлый текст, светлые карточки */
  --color-accent: oklch(0.86 0.17 95); /* жёлтый: кнопки, акценты, разметка, кабина фуры */
  --color-muted: #c9c6bd;        /* подзаголовки, чипы */
  --color-dim: #9a9890;          /* лейблы [ 01 ], «ДЛЯ ЛОГИСТОВ», футер */
  --color-asphalt: #2b2c30;      /* полотно дороги, тёмная плитка выгоды */
  --color-curb: #d8d5cc;         /* краевые линии дороги */
  --color-card-sub: #e6e3da;     /* вложенный блок в карточке контакта */
  --color-card-label: #6b6960;   /* мелкие лейблы на светлых карточках */
  --color-card-text: #4a4840;    /* телефон в карточке */
  --color-trailer: #eeebe3;      /* прицеп фуры */
  --color-car: #e9e6de;          /* легковая */
  --color-glass: #1d2a33;        /* стекло фуры */
  --color-glass-car: #20262c;    /* стекло легковой */
  --color-tyre: #0d0d0d;

  --font-display: "Unbounded", sans-serif;   /* 500, 700 */
  --font-mono: "IBM Plex Mono", monospace;   /* 400, 500 — основной текст */

  --radius-btn: 14px;  /* моб.; десктоп 16px */
}
```
Линии-разделители: `1px solid rgba(242,240,234,.12)` → `border-paper/12`.
Пунктир чипов: `1px dashed rgba(242,240,234,.35)` → `border-dashed border-paper/35`.

**Фон-сетка** (body/обёртка):
```css
background-color: #161719;
background-image:
  linear-gradient(rgba(255,255,255,.04) 1px, transparent 1px),
  linear-gradient(90deg, rgba(255,255,255,.04) 1px, transparent 1px);
background-size: 39px 39px;   /* мобильный; десктоп 48px 48px */
```

**Шрифты:** Google Fonts, с кириллицей — `Unbounded:wght@500;700`, `IBM Plex Mono:wght@400;500`. Лучше self-host через `@fontsource/unbounded` и `@fontsource/ibm-plex-mono` (subset cyrillic + latin), `font-display: swap`.

**Тени:** карточка водителя `0 10px 30px rgba(0,0,0,.4)` (десктоп `0 14px 40px rgba(0,0,0,.45)`); карточка контакта `0 16px 40px rgba(0,0,0,.45)` (десктоп `0 20px 50px`); машины — жёсткая тень `6px 7px 0 rgba(0,0,0,.35)`.

## Типографика
| Элемент | Мобильный | Десктоп |
|---|---|---|
| Логотип | Unbounded 700, 15px, ls .02em | 18px |
| H1 | Unbounded 700, 29px / 1.12, ls -.01em, `text-wrap: balance` | 60px / 1.08, ls -.02em, max-w 600px |
| Подзаголовок | Plex Mono 400, 15px / 1.5, muted | 18px / 1.55, max-w 500px |
| H2 секций | Unbounded 700, 28px, ls -.01em | 44px |
| H2 призыва | Unbounded 700, 29px / 1.15 | 56px / 1.1, max-w 720px |
| Текст пунктов | Plex Mono 15px / 1.5 | 17px (Проблема), 18px (Решение) |
| Плитки выгоды | Unbounded 500, 18px / 1.3 | 24px / 1.3 |
| Кнопка | Unbounded 500, 15px | 17px |
| Лейблы `[ 01 ]`, «ДЛЯ ЛОГИСТОВ» | Plex Mono 11px, ls .08em, dim | 12px |

Акцентные слова в заголовках выделены цветом `accent`: «всегда под рукой!», «всегда во всеоружии!».

## Секции

### Header
Мобильный: flex space-between, padding 22px 24px. Слева квадрат 14×14 accent (radius 3px) + «Волки с Лизюкова». Справа «ДЛЯ ЛОГИСТОВ».
Десктоп: padding 28px 48px; справа «ДЛЯ ЛОГИСТОВ» + outline-кнопка «Перейти в приложение →» (h 44px, px 20px, border `paper/30`, radius 12px, Unbounded 500 13px).

### 01 Hero
**Мобильный** (высота 844px): текстовый блок padding 28px 24px 0, gap 18px: H1 → подзаголовок → кнопка (full width, h 56px, px 22px, bg accent, text ink, radius 14px, стрелка «→» 20px справа, `justify-between`, margin-top 8px).
Нижние 360px — иллюстрация:
- Дорога: 240×760px, bg asphalt, `rotate(-14deg)`, центр по горизонтали, top -150px. Края — линии 3px curb в 10px от краёв. Осевая 4px accent пунктиром: `repeating-linear-gradient(to bottom, accent 0 30px, transparent 30px 62px)`.
- Легковая (в координатах дороги): left 44px, top 165px, 30×58px, radius 9px, color car; лобовое стекло 10px высотой сверху (inset 4px, top 10px), заднее 7px снизу (bottom 8px).
- Фура: left 150px, top 300px, 48×250px. Кабина 44×50px accent, radius 11/11/4/4; стекло 12px (top 6px); зеркала 7×12px tyre по бокам на top 14px; сцепка 12×6px; прицеп 48×194px trailer, radius 3px, поперечные рёбра `repeating-linear-gradient(to bottom, transparent 0 18px, rgba(0,0,0,.07) 18px 19px)`.
- Затухание сверху: gradient `ink → transparent`, высота 90px.
- Карточка водителя поверх: left 24px, top 150px (от начала зоны иллюстрации), w 150px, p 12px 14px, bg paper, radius 12px. «ВОДИТЕЛЬ» 10px / «Смирнов А. В.» Unbounded 500 13px / «★ 4.9 · надёжный» 11px.

**Десктоп** (высота 820px): текст слева, padding-top 110px, max-w 600px, gap 28px; кнопка 380×64px, radius 16px. Иллюстрация занимает правую половину (`left: 50%`), дорога 300×1300px, `rotate(-14deg)`, top -200px; осевая 5px, пунктир 38/78; легковая 38×72 на (56, 420); фура 60×312 на (190, 600). Затухания: сверху 160px, слева 120px. Карточка водителя: left 60px, top 470px, w 200px.

### 02 Проблема
Мобильный: padding 72px 24px 64px, gap 28px, border-top. Заголовок «Проблема» + `[ 01 ]` справа (baseline). Чипы (flex-wrap gap 8px, padding 8px 12px, radius full, 12px, слегка повёрнуты: -3°, 2°+6px, -1°−2px, 4°+4px): телефон / мессенджеры / почта / логистическая платформа. Список: grid `36px 1fr`, gap 12px, padding 20px 0, разделители сверху (и снизу у последнего). Номер 01–03 — 12px accent.
Десктоп: padding 120px 48px, grid `4fr 8fr` gap 64px. Слева лейбл, H2, чипы (max-w 340px). Справа 3 колонки с вертикальными разделителями, номер сверху, gap 40px до текста.

Тексты:
1. Контакты водителей разбросаны по телефону, мессенджерам, почте, логистической платформе
2. Через пол года связь и наработки с человеком теряются
3. Рейтинг контрагентов забывается

### 03 Решение
Карточка контакта (bg paper, text ink, radius 18px / десктоп 22px, p 20px / 28px, gap 16px / 22px; на десктопе `rotate(-1.5deg)`):
- «КАРТОЧКА КОНТАКТА» (10px, card-label) + бейдж «★ 4.9» (bg ink, text accent, radius full, p 4px 10px)
- «Смирнов Алексей Викторович» — Unbounded 500, 18px / десктоп 24px
- «+7 910 249-00-00» — 13px / 15px, card-text
- Вложенный блок bg card-sub, radius 10px, p 12px 14px: «ВЫЖИМКА ПОСЛЕ РАЗГОВОРА» + «попросил аванс 3.000 рублей в счет рейса Воронеж-Москва»

Список (маркер — квадрат 10×10 accent, radius 2px; десктоп 12×12, grid `44px 1fr`):
- Общий список контактов
- В карточке полная информация - номер, ФИО, заметки об общей работе
- После разговора - выжимка в карточку
- Нужен человек - нашли за секунду
- Единый рейтинг надежности водителей и контрагентов

Мобильный: карточка над списком. Десктоп: заголовок сверху, ниже grid `5fr 7fr` gap 64px — карточка слева, список справа.

### 04 Выгода
Три плитки, gap 10px (моб., колонкой) / 16px (десктоп, 3 колонки, min-h 240px, номер сверху, текст прижат вниз). Radius 16px / 20px, padding 22px 20px / 32px 28px.
1. bg accent, text ink — «Помните контекст с каждым контагентом»
2. bg paper, text ink — «Возвращаетесь к договоренностям вовремя»
3. bg asphalt, text paper, номер accent — «Ведете переговоры, полностью погруженные в контекст»

### 05 Призыв + футер
H2 «Веди CRM и будь **всегда во всеоружии!**» + кнопка. Мобильный — колонкой, gap 28px, кнопка full width. Десктоп — в одну строку (`justify-between items-end`), кнопка 380×64.
Ниже горизонтальная дорога (моб.: блок 260px, полотно 120px высотой, `rotate(-8deg)`, top 90px; десктоп: блок 340px, полотно 150px, `rotate(-4deg)`, top 120px). Фура едет вправо (кабина справа). На десктопе дополнительно легковая 72×38 в верхней полосе. Затухание слева (моб. 90px) / слева и справа по 240px (десктоп).
Футер: «ВОЛКИ С ЛИЗЮКОВА» слева, «ДЛЯ ЛОГИСТОВ» справа, 11px / 12px, dim, padding-bottom 28px / 36px.

## Interactions & Behavior
- Все три CTA — `<a href={APP_URL}>`. Hover: `opacity: .9`. Добавить `focus-visible` outline 2px accent, offset 3px.
- Анимаций в макете нет. Опционально: медленное движение машин по дороге через CSS `@keyframes` с `prefers-reduced-motion: reduce` → отключить.
- Никакого JS не требуется; Astro без client-директив.

## Assets
Растровых изображений нет. Дороги, фура и легковая собраны из прямоугольников CSS (см. разметку референсов). Можно перенести как div-ы в Astro-компоненты или переделать в inline SVG с теми же размерами и цветами. Иконки — только текстовые символы «→», «★».

## Copy — заметки
Тексты взяты из `landing-text.md` дословно, плюс правки заказчика (название, телефон, выжимка, «водителей и контрагентов»). В тексте есть опечатки: «контагентом» → «контрагентом», «пол года» → «полгода»; дефисы в пунктах «Решения» можно заменить на тире. **Уточнить у заказчика перед релизом.**

## SEO / meta (заполнить)
`<html lang="ru">`, `<title>`, `meta description`, OG-картинка — в макете не заданы.

## Files
- `design/Landing Mobile.dc.html` — мобильная версия (референс)
- `design/Landing Desktop.dc.html` — десктоп (референс)
- `design/support.js` — рантайм для открытия референсов в браузере
- `design/landing-text.md` — исходный текст лендинга
