# Sotto — project context

Static one-page site for **Sotto**, a specialty coffee and bar service for private
yachts, private parties and sport hospitality on the Côte d'Azur.

`sotto.html` is the approved design. Port it, don't redesign it.

---

## What the site is for

This is **not a lead-generation site.** This market buys through gatekeepers —
concierges, chief stewardesses, charter brokers, event agencies, sponsor
hospitality leads — who book by referral and WhatsApp, not by search.

The site is the link sent after a conversation has already started. Its only job
is to make a gatekeeper comfortable putting their own name behind this supplier.

Consequences:
- No quote form, no booking widget, no lead magnet. One email address.
- No SEO build-out, no blog, no keyword pages.
- No pricing table, no testimonials, no client logos (there are none yet).
- Page weight and load speed matter more than features. Target < 500 KB total.

## Brand

**Name:** Sotto — from *sotto voce*, in a low voice. Discretion is the product.

**Descriptor (always paired with the name, never changed):**
Specialty coffee & bar service

**Positioning:** Every part of a premium event is curated — the wine, the caviar,
the menu. The coffee isn't. It arrives from a pod machine. Sotto fixes the one
category nobody thought about, in places with no kitchen and no bar.

**Three service areas:** Coffee on board (yachts/charters) · Private parties
(villas, pools, terraces) · Sport hospitality (paddock suites, golf hospitality,
stadium VIP, sponsor lounges).

**Commercial model:** Day rate plus travel, minimum one day. Never per cup, never
per guest. Coffee by day, espresso martinis from dusk — one crew, one contract.

**Tier discipline:** VIP tier only. Never concourses, general catering or crew
meals. This appears on the site deliberately; don't soften it.

## Voice

Understated, specific, operational. Short sentences. Specifications over
adjectives. Every competitor in this category shouts; Sotto does not.

Never use: "elevate", "passionate", "artisanal", "journey", "bespoke experience",
"unforgettable", exclamation marks, cup counts, volume claims. No mention of
pizza or any sister brand in customer-facing copy.

Language: English primary. A French version is planned at `/fr/` — same content,
written natively, not machine-translated.

## Design

Deliberate choices — keep them:

- **No accent colour.** The palette is entirely tonal. Adding a brand colour
  contradicts the name. Emphasis comes from space and type.
- **Tonal day arc.** The page runs night → daylight → dusk → night, following a
  service day. Section backgrounds encode this; don't flatten them.
- **No cards, no shadows, no rounded corners.** Hairline rules only, and only
  where they carry structural information (the spec table).
- **One motion moment:** the hero reveal on load. Nothing else animates.
  `prefers-reduced-motion` is respected.

### Tokens (see `:root` in sotto.html)

| Token | Value | Use |
|---|---|---|
| `--night` | `#0E1A21` | Hero, booking, footer |
| `--deep` | `#16242C` | The opening narrative section |
| `--dusk` | `#2A3B45` | Day-into-night section |
| `--paper` | `#E4E2DC` | Daylight sections |
| `--stone` | `#D7D4CD` | Specifications |
| `--light-ink` | `#1A2227` | Text on light |
| `--dark-ink` | `#E9E7E1` | Text on dark |

**Type:** Newsreader (200/300) for the wordmark and headings, lowercase wordmark.
Schibsted Grotesk (400/500) for body. Base 17px, line-height 1.65, measure 62ch.

## Technical decisions

- **No framework.** Plain HTML and CSS. There is no state, no interactivity and
  no content that changes. A build step would be cost without benefit. Revisit
  only if the French version plus a third locale makes duplication painful — then
  Astro, not Next.
- **Self-host the fonts.** Do not ship the Google Fonts CDN link. Serving fonts
  from Google transfers visitor IPs to a US server and has been found to breach
  GDPR in German courts; this site targets EU and Monaco clients. Download
  Newsreader and Schibsted Grotesk, subset to latin + latin-ext, serve as woff2
  from `/fonts/`, with `font-display: swap`.
- **Images:** local in `/img/`, WebP with a JPEG fallback, `loading="lazy"` on
  everything below the hero, explicit width/height to avoid layout shift. The
  hero image is the only one that should be preloaded. Replace the CSS
  `--img-*` variables with real paths; the placeholder `::after` labels come out
  at the same time.
- **Vercel:** static output, no serverless functions needed. Vercel Analytics is
  cookieless and fine for EU; Google Analytics would require a consent banner,
  which this page should not have.

## Legal (must exist before launch)

- Legal notice / Impressum page — Estonian OÜ details, registry number, contact.
- Privacy policy — minimal, since there is no form and no cookies.
- Both linked in the footer. The footer currently has placeholder brackets.

## Still open

- Domain not chosen. `.com` preferred; `sotto.services` or similar as fallback.
  No hyphens, no `.co`.
- Real email address on the domain, replacing `hello@sotto.example`.
- Specification figures in the spec table are placeholders and must be replaced
  with measured values before launch.
- Six images to source or shoot. Stock is acceptable as an interim; nothing with
  visible logos, recognisable faces, or editorial-only sports licensing.
