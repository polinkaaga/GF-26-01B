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
// Необязательные параметры (в скобках — значение по умолчанию):
//   doc-kind ("РЕФЕРАТ")      — вид работы на титуле: "ДОКЛАД", "КУРСОВАЯ РАБОТА" и т. д.
//   topic-prefix ("на тему")  — подпись перед темой; "" — без неё
//   institute, department, direction, program — данные института и программы
//   city ("Красноярск"), year ("2026")
//   show-outline (true)       — false: без содержания
//   outline-depth (2)         — 1: только разделы, 2: разделы и подразделы
//   font-size (14pt)
//
// Номер страницы показывается начиная со страницы, где первый раздел
// (после титула и содержания).
//
// Нужен Typst 0.13 или новее.
// ============================================================

#let serif-fonts = "Times New Roman"

// ---------- Вспомогательные блоки для текста работы ----------
// Прямоугольник для схем внутри #figure(grid(...)):  node[Текст], node(w: 230pt)[Текст]
#let node(body, w: auto) = box(
  width: w,
  inset: (x: 6pt, y: 5pt),
  stroke: 0.7pt,
  radius: 3pt,
  align(center + horizon, text(size: 11pt, body)),
)

// Рамка с пометкой (например, «Для презентации»): #note[Текст]
#let note(body) = block(
  width: 100%,
  inset: 8pt,
  stroke: 0.6pt + luma(120),
  radius: 2pt,
  breakable: false,
)[
  #set par(first-line-indent: 0pt, justify: false, leading: 0.65em)
  #set text(size: 12pt)
  #body
]

// ---------- Титульный лист ----------
#let title-page(
  doc-kind,
  title,
  topic-prefix,
  institute,
  department,
  direction,
  program,
  authors,
  supervisor-title,
  supervisor,
  city,
  year,
  font-size,
) = page(
  numbering: none,
  margin: (left: 3cm, right: 1.5cm, top: 2cm, bottom: 2cm),
)[
  #set text(size: font-size)
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
    #text(size: 14pt, weight: "bold")[#doc-kind] \
    #v(0.6em)
    #if topic-prefix != "" [#topic-prefix «#title»] else [«#title»]
  ]

  #v(1fr)

  #align(center)[#city \ #year]
]

// ---------- Содержание ----------
// Своё, а не стандартный outline(): точки-заполнители до номера страницы, номер прижат
// к правому краю, подразделы сдвинуты на 0,65 см, интервал одинарный, как в образце.
#let toc(depth: 2, font-size: 14pt) = context {
  set text(size: font-size)
  set par(first-line-indent: 0pt, justify: false, leading: 0.5em, spacing: 0.5em)
  let entries = query(heading.where(outlined: true)).filter(hd => hd.level <= depth)

  for i in range(entries.len()) {
    let hd = entries.at(i)
    let loc = hd.location()
    let current-page = counter(page).at(loc).first()
    let previous-page = if i > 0 {
      counter(page).at(entries.at(i - 1).location()).first()
    } else {
      none
    }
    let page-no = if current-page != previous-page { str(current-page) } else { "" }
    let number = if hd.numbering != none {
      [#numbering(hd.numbering, ..counter(heading).at(loc))#h(0.4em)]
    }
    block(width: 100%, above: 0.55em, below: 0.55em, inset: (left: (hd.level - 1) * 0.65cm))[
      #link(loc)[#number#hd.body#h(0.3em)#box(width: 1fr, repeat[.#h(0.2em)])#h(0.3em)#box[#page-no]]
    ]
  }
}

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
  topic-prefix: "на тему", // подпись перед темой на титуле; "" — без неё
  font-size: 14pt,
  show-outline: true,     // false — без содержания
  outline-depth: 2,       // сколько уровней заголовков попадает в содержание
  body,
) = {
  set document(title: title, author: authors)
  set text(font: serif-fonts, size: font-size, lang: "ru", hyphenate: false)

  // 1. Титульный лист (без номера страницы, но считается первой)
  title-page(
    doc-kind, title, topic-prefix, institute, department, direction, program,
    authors, supervisor-title, supervisor, city, year, font-size,
  )

  // 2. Поля: слева 3 см, справа 1 см, сверху и снизу 2 см.
  //    Номер страницы по центру внизу; не показывается на титуле и в содержании.
  set page(
    margin: (left: 3cm, right: 1cm, top: 2cm, bottom: 2cm),
    numbering: "1",
    footer: context {
      let headings = query(heading.where(outlined: true))
      if headings.len() > 0 and here().page() >= headings.first().location().page() {
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

  // 4. Заголовки как в образце: по центру (с абзацным отступом 1,25 см, поэтому чуть правее
  //    середины), жирные, одна пустая строка до и после. Раздел (уровень 1) — с новой
  //    страницы и ПРОПИСНЫМИ. Заголовок «Содержание» без отступа.
  set heading(numbering: "1.1")
  show heading: it => {
    let number = if it.numbering != none {
      [#counter(heading).display(it.numbering)#h(0.3em)]
    }
    let heading-text = if it.level == 1 { upper(it.body) } else { it.body }
    let indent = if it.numbering != none { 1.25cm } else { 0pt }
    if it.level == 1 { pagebreak(weak: true) }
    block(width: 100%, above: 2.3em, below: 2.3em, sticky: true)[
      #set par(first-line-indent: (amount: indent, all: true), justify: false, leading: 0.6em)
      #set align(center)
      #set text(size: font-size, weight: "bold")
      #number#heading-text
    ]
  }

  // 5. Списки: маркер на уровне абзацного отступа, внутри пунктов отступ не нужен
  set list(indent: 1.25cm, body-indent: 0.6em)
  set enum(indent: 1.25cm, body-indent: 0.6em)
  show list: set par(first-line-indent: 0pt)
  show enum: set par(first-line-indent: 0pt)

  // 6. Таблицы: тонкие линии, без абзацного отступа, плотнее, текст по левому краю
  set table(inset: 6pt, align: left, stroke: 0.5pt)
  show table: set par(first-line-indent: 0pt, justify: false, leading: 0.5em, spacing: 0.5em)
  show table: set text(size: 12pt)

  // 6а. Рисунки и таблицы с подписями: «Рисунок 1 – Название» под рисунком,
  //     «Таблица 1 – Название» над таблицей; абзацного отступа внутри нет
  set figure.caption(separator: " – ")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure: set par(first-line-indent: 0pt, justify: false, leading: 0.65em)

  // 6б. Список литературы из #bibliography: без абзацного отступа, по ширине
  show bibliography: set par(first-line-indent: 0pt, justify: true)

  // 7. Содержание
  if show-outline {
    heading(numbering: none, outlined: false)[Содержание]
    toc(depth: outline-depth, font-size: font-size)
  }

  // 8. Сам текст работы
  body
}
