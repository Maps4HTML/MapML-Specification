# MapML Specification — instructions for AI coding models

## Mark AI-written text with `class="llm"`

`spec/index.html` defines a `.llm` style (rendered oblique) that marks prose
written by an AI model, so reviewers can see what still needs human review.

Whenever you add or rewrite text in the specification, wrap that text in the
`llm` class:

- A whole new element (paragraph, list item, note, table cell, …): put the
  class on the element itself, e.g. `<p class="llm">…</p>`. If the element
  already has a class, append to it: `class="note llm"`.
- New or rewritten text inside an existing element: wrap just that text in
  `<span class="llm">…</span>`. Keep links, `<code>` and ReSpec references
  (`[[WCAG22]]`, `[[[HTML]]]`) inside the span.
- Don't add `llm` to text you didn't write, and don't remove an existing
  `llm` class unless asked; the editors remove it once they've reviewed the
  text.
