#import "../lib.typ": *

#show: document.with(
  company_legal: "Qareeb SARL",
  contact_info: "contact@qareeb.io",
  title: "Some Example Document",
  doc_id: "QVIS-SED-001",
  rev: "01",
  date: datetime.today(),
  category: "Qvision",
  sub_category: "Example Reference",
  status: [
    #admonition(type: "IMPORTANT")[
      This document is an example
    ]
  ],
)

= Document Scope & Audience

== About This Document

#admonition(type: "warning", title: "What This Document IS NOT")[]

== How to Read This Document

=== For Someone
- *Read:*
- *Scan:*
- *Skip:*

= Introduction

== Objective

== System Purpose
