// ============================================================
// template.typ — Шаблон по СТО 7.5-07–2021
// Версия Typst: 0.14.2
// ============================================================

// Главная функция-шаблон. Принимает метаданные и тело документа.
#let university-doc(
  title: "Название документа",
  author: "",
  department: "",
  year: "2026",
  doc,          // ← это тело документа, всегда последним
) = {

  // ── 1. НАСТРОЙКИ СТРАНИЦЫ ─────────────────────────────────
  // Раздел 7.1.1: формат А4 (210×297 мм), поля в мм
  set page(
    paper: "a4",
    margin: (
      top:    20mm,  // верхнее поле: 20 мм  (7.1.2)
      bottom: 20mm,  // нижнее поле: 20 мм   (7.1.2)
      left:   30mm,  // левое поле: 30 мм    (7.1.2, для переплёта)
      right:  10mm,  // правое поле: 10 мм   (7.1.2)
    ),
    // Нумерация страниц — внизу по центру (7.1.3)
    numbering: "1",
    number-align: center + bottom,
  )

  // ── 2. ОСНОВНОЙ ТЕКСТ ─────────────────────────────────────
  // Раздел 7.1.1: шрифт Times New Roman 14 пт, межстрочный 1.5
  set text(
    font: "Times New Roman",
    size: 14pt,
    lang: "ru",
    hyphenate: false,
  )

  // Межстрочный интервал 1.5 (7.1.1)
  set par(
    leading: 1.5em,        // межстрочный интервал
    first-line-indent: 12.5mm,  // красная строка 12.5 мм (7.1.1)
    justify: true,         // выравнивание по ширине (7.1.1)
  )

  // ── 3. ЗАГОЛОВКИ ──────────────────────────────────────────
  // Раздел 7.4: нумерованные разделы
  // Уровень 1 (раздел): жирный, по центру, 14 пт
  show heading.where(level: 1): it => {
    set text(size: 14pt, weight: "bold")
    set align(center)
    set par(first-line-indent: 0mm)
    v(1em)           // отступ перед заголовком
    upper(it.body)
    v(0.5em)         // отступ после заголовка
  }

  // Уровень 2 (подраздел): жирный, от левого края
  show heading.where(level: 2): it => {
    set text(size: 14pt, weight: "bold")
    set par(first-line-indent: 0mm)
    v(0.75em)
    it.body
    v(0.5em)
  }

  // Уровень 3 (пункт): жирный курсив, от левого края
  show heading.where(level: 3): it => {
    set text(size: 14pt, weight: "bold", style: "italic")
    set par(first-line-indent: 0mm)
    v(0.5em)
    it.body
    v(0.25em)
  }

  // Нумерация заголовков (раздел 7.4.2: 1, 1.1, 1.1.1)
  set heading(numbering: "1.1.1")

  // ── 4. РИСУНКИ ────────────────────────────────────────────
  // Раздел 7.5: подпись «Рисунок Х — Название», по центру
  show figure.where(kind: image): it => {
    set align(center)
    it.body
    v(0.3em)
    set text(size: 14pt)
    [Рисунок #it.counter.display() — #it.caption.body]
  }

  // ── 5. ТАБЛИЦЫ ────────────────────────────────────────────
  // Раздел 7.7: «Таблица Х — Название» над таблицей, слева
  show figure.where(kind: table): it => {
    set align(left)
    set text(size: 14pt)
    [Таблица #it.counter.display() — #it.caption.body]
    v(0.3em)
    it.body
  }

  // ── 6. СПИСОК ЛИТЕРАТУРЫ ──────────────────────────────────
  // ГОСТ Р 7.0.100–2018 (раздел 2 стандарта)
  set bibliography(style: "gost-r-7-0-5-2008-numeric.csl")

// Нумерованный список: 1) 2) 3)
set enum(
  numbering: "1.",        // формат номера
  indent: 12.5mm,         // отступ = красная строка
  body-indent: 5mm,       // отступ текста от номера
)

// Маркированный список (для полноты)
set list(
  indent: 12.5mm,
  body-indent: 5mm,
  marker: "–",            // тире по ГОСТ
)

// ── 7. ОСНОВНОЕ СОДЕРЖИМОЕ ДОКУМЕНТА ─────────────────────
  doc
}

#let title-page(
     font: "Times New Roman",
  ministry: "Министерство науки и высшего образования РФ",
  university: "«СИБИРСКИЙ ФЕДЕРАЛЬНЫЙ УНИВЕРСИТЕТ»",
  institute: "",
  department: "",

  work-type: "РЕФЕРАТ",
  work-topic: "",
  discipline: "",

  teacher: "",
  students: ("",),
  group: "",

  city: "Красноярск",
  year: "2026",
) = {
  set text(size: 14pt, font: font)   // ← добавить font: font
  set page(
    numbering: none,
    paper: "a4",
    margin: (
      top:    20mm,  // верхнее поле: 20 мм  (7.1.2)
      bottom: 20mm,  // нижнее поле: 20 мм   (7.1.2)
      left:   30mm,  // левое поле: 30 мм    (7.1.2, для переплёта)
      right:  10mm,  // правое поле: 10 мм   (7.1.2)
    ),
    footer: align(center, text(size: 14pt)[#city #year]),
  )

  // ── 1. ШАПКА ───────────────────────────────────────────────
  align(center)[
  #ministry \
  Федеральное государственное автономное \
  образовательное учреждение высшего образования \
  *#university*

  #v(0.5em)
  #if institute != "" [#institute \
  ]
  #if department != "" [#department]
  ]

  v(10em)


  // ── 3. ЦЕНТРАЛЬНЫЙ БЛОК ────────────────────────────────────
  align(center)[
  *#upper(work-type)*

  #v(1em)
  по дисциплине «#discipline»

  #v(1.5em)
  "#work-topic"
  ]

  v(2.5em)


   // ── 5. БЛОК ПРЕПОДАВАТЕЛЯ И СТУДЕНТОВ ────────────────────

v(1.5em)
grid(
  columns: (1fr, 1fr),
  gutter: 10pt,

  [
    Преподаватель

    #v(1.5em)
    Студенты #group
  ],

  [
    #align(right)[
      #teacher

      #v(1.5em)
      #for (i, student) in students.enumerate() [
        #student
        #if i < students.len() - 1 [
          #v(0.5em)
        ]
      ]
    ]
  ],
)
}

#let toc() = {
  // Принудительно одинарный интервал для всего содержания
  set par(leading: 0.65em)
  set block(spacing: 0.65em)  // убирает лишние отступы между строками

  align(center, text(weight: "bold")[СОДЕРЖАНИЕ])
  v(1em)

  show outline.entry.where(level: 1): it => {
    set text(weight: "regular")
    it
  }

  show outline.entry.where(level: 2): it => {
    set text(weight: "regular")
    pad(left: 4pt, it)
  }

  show outline.entry.where(level: 3): it => {
    set text(weight: "regular")
    pad(left: 8pt, it)
  }

  outline(
    title: none,
    indent: 0pt,
    depth: 3,
  )

  pagebreak()
}