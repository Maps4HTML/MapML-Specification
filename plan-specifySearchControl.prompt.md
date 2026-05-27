## Plan: Specify Search Control in MapML Specification

Specify the `search`/`suggestions` link relations, the `search` controlslist token, the `zoomToExtent()` API method, and the `mapsearch`/`mapsuggestions` events in [spec/index.html](MapML-Specification/spec/index.html), following W3C specification conventions already established in the document (respec CG-DRAFT format).

---

### Phase 1: `controlslist` — Add `search` Token

**Step 1a: Update allowed values list** (~line 555)
- Add `search` to the paragraph listing allowed `controlsList` DOMTokenList values, alongside `nofullscreen`, `nolayer`, etc. Add anchor `<a href="#attr-mapviewer-controlslist-search">`.

**Step 1b: Add `search` keyword definition** (after `geolocation`, ~line 575)
- Define `<dfn id="attr-mapviewer-controlslist-search">search</dfn>` following the `geolocation` pattern. Key points:
  - Opt-in token (adds a control), unlike `no*` tokens. Must be explicitly called out.
  - The search control allows place-name search and map navigation.
  - SHOULD be disabled (`aria-disabled="true"`) until at least one `checked` `layer` provides a `link[@rel=search]`.
  - Queries all checked layers with search links in parallel, substituting `{searchTerms}`.

**Step 1c: Extend "expose a user interface" paragraph** (~line 537)
- Add "search for geographic places by name" to the list of user interface features.

---

### Phase 2: `link` Element — Add `search` and `suggestions` Rel Values

**Step 2a: Add rows to `@rel` values table** (after `query` row, ~line 2080)
- `<tr id="link-rel-search">`: `search` — URL template (`tref`) for a geocoding endpoint; MUST contain `{searchTerms}` variable reference; first per layer honored.
- `<tr id="link-rel-suggestions">`: `suggestions` — URL template for typeahead/autocomplete; same `{searchTerms}` substitution; optional but recommended; first per layer honored.

**Step 2b: Update link element contexts** (~line 1908)
- Add a new context for links with `rel` in the `search` or `suggestions` state: in local content, as a child of `layer`; in remote content, as a child of `head`. This is distinct from the existing `extent`-child context for `tile`/`image`/`features`/`query` links.

**Step 2c: Add prose for search/suggestions behaviour**
- Describe that `search`/`suggestions` links use `tref` (not `href`) with URL templates.
- Describe `{searchTerms}` as a **predefined template variable** bound to user text input from the search control — this is a departure from existing template variables which are bound to sibling `input` elements. Inspired by OpenSearch `{searchTerms}`.
- The user agent SHOULD debounce suggestions requests and require a minimum query length.
- In remote content, links go in `head`; in local content, direct children of `layer`.
- Default response format is GeoJSON `FeatureCollection` [[rfc7946]] (informative, not normative on servers).

---

### Phase 3: WebIDL — Add `zoomToExtent()` and Events

**Step 3a: Add `zoomToExtent()` to WebIDL** (~line 479)
- `undefined zoomToExtent(double west, double south, double east, double north);` after existing `zoomTo()`.

**Step 3b: Add `zoomToExtent()` prose** (after `zoomTo()` prose, ~line 530)
- Fits the viewport to the geographic extent (decimal degrees, west-south-east-north). Zoom level selected automatically.

**Step 3c: Define `mapsearch` and `mapsuggestions` events**
- New sub-section or prose block. Both are `CustomEvent`s, bubble, cancelable.
- `event.detail`: `{ query (DOMString), responses (sequence of { data, link, layer }), setResults (callback) }`.
- If `preventDefault()` is called, user agent MUST NOT perform default rendering/navigation.
- Default handler: expects GeoJSON FeatureCollection, navigates to first result's `bbox` or `geometry.coordinates`.

**Step 3d: Document `setResults()` item shape**
- `text` (DOMString, required), `value` (DOMString, optional — triggers re-search), `lat`/`lng` (double, optional), `bbox` (sequence<double>[4], optional).

---

### Phase 4: Schema Update

**Step 4: Update `mapml.rnc`**
- The `rel` attribute currently uses open `text` type, so no strict change is needed. If the spec ever tightens the enumeration, include `search` and `suggestions`.
- Same for `mapml-viewer.rnc` if `controlslist` is enumerated.

---

### Phase 5: Authoring Examples & Changelog

**Step 5a: Add or update an authoring example**
- Demonstrate `<mapml-viewer controls controlslist="search">` with a `<map-link rel="search" tref="...{searchTerms}...">` — either update existing example 2 or add a third example.

**Step 5b: Update changelog**
- Add entry with date, summarizing: `search` controlslist token, `search`/`suggestions` rel values, `zoomToExtent()`, `mapsearch`/`mapsuggestions` events.

---

### Relevant Files

| File | Action |
|------|--------|
| [spec/index.html](MapML-Specification/spec/index.html) | Primary — all changes |
| [schema/mapml.rnc](MapML-Specification/schema/mapml.rnc) | Possibly add to rel enumeration |
| [schema/mapml-viewer.rnc](MapML-Specification/schema/mapml-viewer.rnc) | Possibly add `search` to controlslist |

**Reference files (read-only):**
- [SearchButton.js](MapML.js/src/mapml/control/SearchButton.js) — canonical implementation
- [mapml-viewer.js](MapML.js/src/mapml-viewer.js#L1085) — `zoomToExtent()` implementation
- [search.md](web-map-doc/docs/user-guide/search.md) — user-facing docs
- [custom-handlers.md](web-map-doc/docs/user-guide/custom-handlers.md) — custom handler docs

---

### Verification

1. Open `spec/index.html` in browser — confirm no respec errors, all anchors resolve
2. Verify all new `<dfn>` IDs are unique
3. Verify WebIDL parses without errors (respec highlights IDL issues)
4. Verify `search`/`suggestions` table rows link correctly to prose
5. Cross-reference spec prose against `SearchButton.js` implementation for accuracy
6. Verify examples render correctly

---

### Decisions

- `search` is opt-in (like `geolocation`), not `no*`-pattern — must be explicit
- `search`/`suggestions` links use `tref` not `href`, but their context is `head`/`layer` not `extent`
- `{searchTerms}` is a predefined template variable, not derived from `input` siblings — a new mechanism that needs clear description
- Default GeoJSON response handling is informative, not normative on servers
- `zoomToExtent()` takes geographic coordinates in west-south-east-north order

### Further Considerations

1. **`{searchTerms}` template variable semantics**: This is a new kind of variable — predefined and bound to user input rather than sibling `input` elements. The spec should clearly describe this distinction. Consider referencing OpenSearch as prior art (add to `localBiblio`?).

2. **Normative vs informative for default handler**: The GeoJSON default should be informative (NOTE). The normative requirements are: the events, their cancelability, and `setResults()`.

3. **OpenSearch reference**: `{searchTerms}` is borrowed from OpenSearch. Worth a brief reference but MapML's use is simpler (no formal description document). Up to you whether to add to `localBiblio`.

---

### Post-Spec Follow-Up

1. **Update doc pages' Specifications tables**: Once the spec sections are written, add links from the web-map-doc pages (`mapml-viewer.md`, `link.md`, `mapml-viewer-api.mdx`) Specifications tables to the corresponding new spec anchors.
