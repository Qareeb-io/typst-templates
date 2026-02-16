#let document(
  company: none,
  company_legal: "Qareeb SARL",
  contact_info: "contact@qareeb.io",
  title: "Document Title",
  doc_id: "ID-000",
  date: datetime.today(),
  category: "Technical Reference",
  sub_category: none,
  logo: image("../assets/logo.svg"),
  status: none,
  footer: none,
  confidentiality: "Internal Use Only",
  accent_color: rgb("2E0B5E"),
  authors: (),
  reviewers: (),
  approvers: (),
  history: (),
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
          text(weight: "bold", doc_id), align(right, [Rev. #history.last().revision]),
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
        #text(20pt, weight: "bold")[#doc_id REV.#history.last().revision] \
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

    #footer

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

  // --- DOCUMENT CONTROL ---
  if authors.len() > 0 or history.len() > 0 {
    pagebreak()
    heading(level: 1, numbering: none)[Document Control]
    v(1em)

    // 1. Document Identification Table
    text(11pt, weight: "bold")[1. Document Identification]
    table(
      columns: (1fr, 1fr),
      stroke: 0.5pt + gray,
      fill: (col, _) => if col == 0 or col == 2 { gray.lighten(95%) },
      [*Doc ID*], [#doc_id],
      [*Status*], [#status],
      [*Classification*], [#sub_category],
      [*Revision*], [#if history.len() > 0 { history.last().revision } else { "01" }],
    )
    v(1.5em)

    let format-row(role, person) = {
      let date-str = if "date" in person {
        if type(person.date) == datetime {
          person.date.display("[month repr:long] [day], [year]")
        } else { person.date }
      } else { "-" }

      (role, person.name, date-str, "") // The row array
    }

    // 2. Sign-off and Approval Table (Consolidated)
    text(11pt, weight: "bold")[2. Document Approval]
    table(
      columns: (0.5fr, 1fr, 1fr, 1fr),
      align: (left, left, left, center),
      stroke: 0.5pt + gray,
      fill: (_, row) => if row == 0 { gray.lighten(90%) },
      table.header[*Role*][*Name*][*Date*][*Signature*],
      ..authors.map(p => format-row("Author", p)).flatten(),
      ..reviewers.map(p => format-row("Reviewer", p)).flatten(),
      ..approvers.map(p => format-row("Approver", p)).flatten(),
    )
    v(1.5em)

    // 3. Revision History
    if history.len() > 0 {
      text(11pt, weight: "bold")[3. Revision History]
      table(
        columns: (0.5fr, 1.5fr, 2.5fr, 1.8fr),
        align: (center, center, left, left),
        stroke: 0.5pt + gray,
        fill: (_, row) => if row == 0 { gray.lighten(90%) },
        table.header[*Rev.*][*Date*][*Description of Change*][*Author*],
        ..history
          .map(h => (
            h.revision,
            if type(date) == datetime {
              date.display("[month repr:long] [day], [year]")
            } else {
              date
            },
            h.description,
            h.author,
          ))
          .flatten(),
      )
    }

    pagebreak()
  }

  // --- Body Styles ---
  set heading(numbering: "1.1.1")
  show heading: it => [
    #v(1.2em, weak: true)
    #it
    #v(0.6em, weak: true)
  ]
  set par(justify: true, leading: 0.65em)

  show heading.where(level: 1): it => {
    if it.has("label") and it.label == <no-break> {
      it
    } else {
      pagebreak(weak: true)
      it
    }
  }

  outline(indent: auto)

  pagebreak(weak: true)

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
