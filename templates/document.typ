#let document(
  company: none,
  company_legal: "Qareeb SARL",
  contact_info: "contact@qareeb.io",
  title: "Document Title",
  doc_id: "ID-000",
  rev: "01",
  date: datetime.today(),
  category: "Technical Reference",
  sub_category: none,
  logo: image("../assets/logo.svg"),
  status: none,
  confidentiality: "Internal Use Only",
  accent_color: rgb("2E0B5E"),
  body,
) = {
  set text(font: "Helvetica", size: 11pt)

  // --- Page Layout Setup ---
  set page(
    // Asymmetric margins are great for binding
    margin: (left: 30mm, right: 20mm, top: 25mm, bottom: 25mm),
    header: {
      set text(8pt, fill: gray.darken(50%))
      stack(
        spacing: 4pt,
        grid(
          columns: (1fr, 1fr),
          text(weight: "bold", doc_id), align(right, [Rev #rev]),
        ),
        line(length: 100%, stroke: 0.5pt + gray),
      )
    },
    footer: context {
      set text(8pt, fill: gray.darken(50%))
      stack(
        spacing: 4pt,
        line(length: 100%, stroke: 0.5pt + gray),
        grid(
          columns: (1fr, 1fr),
          align(left, emph(title)), align(right, [Page #counter(page).display("1 / 1", both: true)]),
        ),
      )
    },
  )

  // --- TITLE PAGE ---
  page(header: none, footer: none)[
    // Top Logo & Company
    #if logo != none {
      grid(
        columns: (auto, 1fr),
        gutter: 15pt,
        align: horizon,
        {
          set image(height: 35pt)
          logo
        },
        text(company, 14pt, weight: "regular", tracking: 1pt),
      )
    } else {
      align(left)[#text(company, 14pt, weight: "regular", tracking: 1pt)]
    }

    #v(4cm)

    // Category and ID Block
    #grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      align(bottom)[
        #text(32pt, weight: "bold", fill: accent_color)[#category]
      ],
      align(right + bottom)[
        #text(20pt, weight: "bold")[#doc_id REV.#rev] \
        #text(12pt, weight: "regular")[
          #if type(date) == datetime {
            date.display("[month repr:long] [day], [year]")
          } else {
            date
          }
        ]
        #if sub_category != none {
          block(above: 0.5em)[#text(12pt, weight: "bold")[#sub_category]]
        }
      ],
    )

    #line(length: 100%, stroke: 1.5pt + accent_color)

    #text(32pt, weight: "bold")[#title]

    #v(1fr)

    #status

    // Title Page Footer
    #align(bottom)[
      #line(length: 100%, stroke: 0.5pt + gray)
      #set text(8pt, fill: gray.darken(50%))
      #grid(
        columns: (1fr, 1fr),
        [
          #text(weight: "bold", company_legal) \
          #if contact_info != none { link("mailto:" + contact_info) }
        ],
        align(right)[
          #text(weight: "bold", confidentiality) \
          © #datetime.today().year() All Rights Reserved
        ],
      )
    ]
  ]

  // --- Body Styles ---
  set heading(numbering: "1.1.1")
  show heading: it => [
    #v(1.2em, weak: true)
    #it
    #v(0.6em, weak: true)
  ]
  set par(justify: true, leading: 0.65em)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }

  outline(indent: auto)

  body
}

#let admonition(type: "NOTE", title: none, body) = {
  let color = (
    "NOTE": rgb("#2563eb"), // Blue
    "IMPORTANT": rgb("#d97706"), // Orange
    "WARNING": rgb("#dc2626"), // Red
    "TIP": rgb("#059669"), // Green
  ).at(upper(type), default: gray.darken(20%))

  let heading = if title != none { title } else { upper(type) }

  block(
    width: 100%,
    stroke: (left: 4pt + color, rest: 1pt + color.lighten(80%)),
    fill: color.lighten(95%),
    inset: 12pt,
    radius: 4pt,
    [
      #text(weight: "bold", fill: color)[#heading] \
      #set text(fill: black.lighten(10%))
      #body
    ],
  )
}
