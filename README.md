# Qareeb Typst Templates

Welcome to **Qareeb** Typst templates. This collection ensures that all our internal and external documents—from technical reports to invoices—remain consistent, professional, and easy to produce.

## Quick Start

To use a template from this repository, you can either copy the folder or reference it locally.

1. **Install Typst:** Ensure you have the [Typst CLI](https://github.com/typst/typst) installed.
2. **Clone this repo:**
```bash
git clone https://github.com/qareeb-io/typst-templates.git
```
3. **Compile a document:**
```bash
typst compile typst-templates/examples/document.typ output.pdf
```

---

## Available Templates

| Name | Description | Path |
| --- | --- | --- |
| **Engineering Documents** | Standard internal engineering documents. | `/template.typ` |

---

## How to Use

Each template is designed as a **function**. Instead of editing the template file directly, you should import it into your `main.typ`.

### Example

```typst
#import "./template.typ": *

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

= Introduction
Your content starts here...

```

---

### Fonts
```bash
export TYPST_FONT_PATHS="<template dir>/assets/fonts"
```

## Repository Structure

* `/assets`: Common logos, fonts, and icons.
* `/examples`: Some helpful examples.

---

> **Note:** These templates are for internal company use only. Please do not share with external parties without permission.
