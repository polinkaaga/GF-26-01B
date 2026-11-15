// ============================================================
// sibfu-template.typ — шаблон оформления учебных работ СФУ
//
// Подключение в основном файле:
//
//   #import "sibfu-template.typ": university-doc
//   #show: university-doc.with(
//     title: "Тема работы",
//     authors: ("И. О. Фамилия",),
//     supervisor-title: "ст. преподаватель",
//     supervisor: "И. О. Фамилия",
//   )
//
// После этого в основном файле остаётся только текст:
//   = Заголовок раздела            (нумеруется: «1 ЗАГОЛОВОК РАЗДЕЛА»)
//   == Заголовок подраздела        (нумеруется: «1.1 Заголовок подраздела»)
//   #heading(numbering: none)[Введение]   (раздел без номера)
//
// Шаблон сам делает: титульный лист, содержание, поля, нумерацию
// страниц, шрифт, интервалы, абзацные отступы, вид заголовков,
// новую страницу для каждого раздела, оформление списков и таблиц.
//
// Нужен Typst 0.13 или новее.
// ============================================================

#let serif-fonts = ("Times New Roman", "Liberation Serif", "Tinos")

// ---------- Титульный лист ----------
#let title-page(
  doc-kind,
  title,
  institute,
  department,
  direction,
  program,
  authors,
  supervisor-title,
  supervisor,
  city,
  year,
) = page(
  numbering: none,
  margin: (left: 3cm, right: 1.5cm, top: 2cm, bottom: 2cm),
)[
  #set par(justify: false, first-line-indent: 0pt, leading: 0.65em, spacing: 0.65em)

  #align(center)[
    МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ \
    РОССИЙСКОЙ ФЕДЕРАЦИИ \
    Федеральное государственное автономное образовательное учреждение высшего образования \
    *«СИБИРСКИЙ ФЕДЕРАЛЬНЫЙ УНИВЕРСИТЕТ»* \
    #institute \
    #department
  ]

  #v(1fr)

  #align(center)[
    #text(size: 20pt, weight: "bold")[#doc-kind] \
    #v(0.6em)
    на тему «#title»
  ]

  #v(1fr)

  Направление подготовки: #direction \
  Образовательная программа: #program

  #v(2em)

  #align(right)[
    #block(width: 55%)[
      #set align(left)
      #if authors.len() > 0 [
        *#if authors.len() > 1 [Выполнили:] else [Выполнил:]* \
        #authors.join(linebreak())
      ]
      #if supervisor != "" [
        #v(1em)
        *Проверил:* \
        #supervisor-title \
        #supervisor
      ]
    ]
  ]

  #v(1fr)

  #align(center)[#city \ #year]
]

// ---------- Основная функция шаблона ----------
#let university-doc(
  title: "",
  doc-kind: "РЕФЕРАТ",
  authors: (),
  supervisor-title: "",
  supervisor: "",
  institute: "Гуманитарный институт",
  department: "Кафедра информационных технологий в креативных и культурных индустриях",
  direction: "09.03.03 Прикладная информатика",
  program: "09.03.03.35 Прикладная информатика в искусстве и интерактивных медиа",
  city: "Красноярск",
  year: "2026",
  outline-depth: 1,       // сколько уровней заголовков попадает в содержание
  first-numbered-page: 3, // с какой страницы показывать номер (титул = 1, содержание = 2)
  body,
) = {
  set document(title: title, author: authors)
  set text(font: serif-fonts, size: 14pt, lang: "ru", hyphenate: false)

  // 1. Титульный лист (без номера страницы, но считается первой)
  title-page(
    doc-kind, title, institute, department, direction, program,
    authors, supervisor-title, supervisor, city, year,
  )

  // 2. Поля и нумерация остальных страниц: слева 3 см, справа 1 см, сверху и снизу 2 см
  set page(
    margin: (left: 3cm, right: 1cm, top: 2cm, bottom: 2cm),
    numbering: "1",
    footer: context {
      let n = counter(page).get().first()
      if n >= first-numbered-page {
        align(center, counter(page).display("1"))
      }
    },
  )

  // 3. Основной текст: абзацный отступ 1,25 см (в том числе после заголовка),
  //    интервал 1,5, выравнивание по ширине, пустых строк между абзацами нет
  set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
    leading: 0.6em,
    spacing: 0.6em,
  )

  // 4. Заголовки: по центру, жирные, без абзацного отступа,
  //    одна пустая строка до и после. Раздел (уровень 1) — с новой страницы и ПРОПИСНЫМИ.
  set heading(numbering: "1.1")
  show heading: it => {
    let number = if it.numbering != none {
      [#counter(heading).display(it.numbering)#h(0.3em)]
    }
    let heading-text = if it.level == 1 { upper(it.body) } else { it.body }
    if it.level == 1 { pagebreak(weak: true) }
    block(width: 100%, above: 2.3em, below: 2.3em, sticky: true)[
      #set par(first-line-indent: 0pt, justify: false, leading: 0.6em)
      #set align(center)
      #set text(weight: "bold")
      #number#heading-text
    ]
  }

  // 5. Списки: маркер на уровне абзацного отступа, внутри пунктов отступ не нужен
  set list(indent: 1.25cm, body-indent: 0.6em)
  set enum(indent: 1.25cm, body-indent: 0.6em)
  show list: set par(first-line-indent: 0pt)
  show enum: set par(first-line-indent: 0pt)

  // 6. Таблицы: без абзацного отступа, плотнее, текст по левому краю
  set table(inset: 6pt, align: left)
  show table: set par(first-line-indent: 0pt, justify: false, leading: 0.5em, spacing: 0.5em)

  // 7. Содержание: без абзацного отступа, подпункты сдвинуты, номер страницы справа
  set outline(indent: 0.65cm, fill: none)
  show outline: set par(first-line-indent: 0pt, justify: false, leading: 0.4em, spacing: 0.4em)
  show outline: set block(spacing: 0.4em)
  outline(title: [Содержание], depth: outline-depth)

  // 8. Сам текст работы
  body
}
