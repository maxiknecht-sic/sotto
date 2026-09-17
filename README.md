# Sotto — website

Static one-page site for **Sotto**, a specialty coffee and bar service for private yachts,
private parties and sport hospitality on the Côte d'Azur.

The design is the approved `sotto.html` comp, ported unchanged. See `CLAUDE.md` for the
brief: what the site is for, the voice, and which design decisions are deliberate.

## Stack

There isn't one. Plain HTML and CSS, no framework, no build step, no JavaScript.
There is no state, no interactivity and no content that changes, so a build step would
be cost without benefit.

- Fonts are **self-hosted** (`/fonts/`). No request reaches Google Fonts, so no visitor
  IP is transferred to a US server — the point of the exercise for an EU/Monaco audience.
- No cookies, no analytics, no tracking pixels. That is why there is no consent banner.
- Total page weight on first load is well under the 500 KB budget (see *Weight* below).

## Run it locally

Any static server will do:

```bash
python3 -m http.server 4000
```

Then open <http://localhost:4000>. Note that `/legal/` and `/privacy/` resolve through
their `index.html`, exactly as they do on Vercel.

## Structure

```
index.html          the page — all markup and all CSS for it, inline, one request
legal/index.html    legal notice (Estonian OÜ details)
privacy/index.html  privacy policy
assets/page.css     shared styles for the two legal pages only
assets/favicon.svg  wordmark favicon
assets/og.png       1200×630 social preview image
fonts/*.woff2       Newsreader + Schibsted Grotesk, latin and latin-ext subsets
img/                photography, WebP + JPEG (mixed provenance — see below)
robots.txt          allows everything, points at the sitemap
sitemap.xml         one URL, the homepage
vercel.json         static config, caching and security headers
scripts/configure.sh  sets the domain and email across every file
```

## Before launch

This is a concept. The operating company is deliberately not named: `/legal/` and
`/privacy/` say so in place of the registered entity, registry code, VAT number, address
and board member. Those go in before the site goes live — the EU E-Commerce Directive
and the Estonian Commercial Code both require them, and `dl.facts` in `assets/page.css`
is the layout they return to.

Two values are still placeholders. One command sets both:

```bash
./scripts/configure.sh --domain sotto.com --email hello@sotto.com
```

That rewrites the canonical, the Open Graph URLs, the JSON-LD, `robots.txt`,
`sitemap.xml` and every `mailto:` link.

The figures in the **Specifications** table on the homepage are still the comp's
placeholder numbers. Measure the real rig and replace them — that table is the part of
this page a chief stewardess will actually read twice.

## The photography

There are two mechanisms, because the page uses images in two ways.

**The three service-area images** in "Where we work" are real `<picture>` elements —
WebP with a JPEG fallback, `loading="lazy"`, explicit `width`/`height` so nothing shifts
as they load. Swap one by replacing `img/area-<name>.webp` and `.jpg`. Export at
760 × 1013 (3:4); the grid never renders them wider than about 380 px.

**The hero and the full-width band** are CSS backgrounds, driven by variables at the
top of `index.html`, because they bleed edge to edge:

```css
--img-hero:image-set(url("/img/hero.webp") type("image/webp"),
                     url("/img/hero.jpg")  type("image/jpeg"));
```

### Provenance — read before launch

| Slot | Source | Licence |
|---|---|---|
| `hero` | Pexels #34155535, 1800 px | Pexels licence — free commercial use, no attribution |
| `night` | supplied by the client, 736 px | **unverified** |
| `area-yachts`, `area-parties`, `area-sport` | supplied by the client, ~736 px | **unverified** |

**The four supplied images arrived without a licence and their rights are not
established.** They came in at 735–736 px, which is Pinterest's standard export width.
That resolution is fine in the grid — each column is only about 380 px — but `night`
runs full width, where 736 px is stretched. It gets away with it because the shot is
shallow-focus, so the softness reads as depth of field rather than a small file. The
rights are the real problem, not the pixels. Confirm ownership, buy a licence, or
reshoot before launch.

Two of them were also cropped to satisfy the brief's own rules, and the crops are the
only thing holding those rules: `area-yachts` is pushed right so branded soft-drink cans
at the left of the bar fall outside the frame, and `area-parties` is pulled wide so the
bartender reads as a figure at the bar rather than a portrait. Re-crop either one and
those problems come back.

Rules from the brief: nothing with visible logos, recognisable faces, or editorial-only
sports licensing. There is no image tooling in this repo; the current set was produced
with `sharp`.

## Weight

Measured from what is actually served. Everything is cached for a year after the first
visit.

| | |
|---|---|
| `index.html` (markup + all CSS) | ~17 KB |
| `newsreader-latin.woff2` | ~129 KB |
| `schibsted-grotesk-latin.woff2` | ~46 KB |
| `hero.webp` (preloaded) | ~85 KB |
| **Above the fold** | **~276 KB** |
| three service-area images (WebP, lazy) | ~152 KB |
| `night.webp` (full-width band) | ~20 KB |
| **Whole page** | **~449 KB** |

Inside the 500 KB budget. The hero is held at WebP quality 58 and 1800 px: open water is
expensive to compress, and at quality 76 and 2200 px the same shot cost 168 KB and put
the page over budget. It survives the lower setting because the subject is near-abstract
dark water, where lost detail is invisible — a sharp-edged photograph would not.

The band image is a CSS background, which is not deferred the way `loading="lazy"`
defers an `<img>`, so it is fetched on the first visit rather than on scroll. The three
grid images are genuinely lazy.

The `latin-ext` font files ship too but are only fetched if a page actually uses an
Eastern European character, because each `@font-face` carries a `unicode-range`. They
cost nothing on a normal visit.

## Deployment

GitHub → Vercel, static, no serverless functions.

1. Push this repository to GitHub.
2. In Vercel, **Add New → Project**, import the repo.
3. Framework preset: **Other**. Leave the build command and output directory empty —
   `vercel.json` already declares them, and there is nothing to build.
4. Add the domain under **Settings → Domains**, then point the registrar's nameservers
   or A/CNAME records at Vercel.
5. Run `./scripts/configure.sh` with the real domain and commit, so the canonical and
   the sitemap agree with where the site actually lives.

`vercel.json` sets long-lived immutable caching for `/fonts/`, `/assets/` and `/img/`,
plus HSTS, `X-Content-Type-Options`, `Referrer-Policy`, `X-Frame-Options`,
`Permissions-Policy` and a Content Security Policy that allows only same-origin assets.

### Analytics

Deliberately none. Vercel Analytics is cookieless and would be defensible under GDPR,
but it adds a script to a page whose whole argument is restraint. If you turn it on,
add a paragraph to `/privacy/` naming it — the current policy states that nothing is
collected, and that has to stay true.

## Findability

Not an SEO build-out — this market books by referral, not by search, and the brief is
explicit about that. What is here is the hygiene that makes the page legible to a
crawler when someone does look the name up:

- unique `<title>` and meta description, self-referencing canonical
- `robots.txt` allowing everything, plus a sitemap
- Open Graph and Twitter card tags with a real 1200×630 preview image
- `ProfessionalService` JSON-LD: the three service areas and `areaServed` for Monaco,
  Cannes and the Côte d'Azur
- semantic landmarks, one `h1`, a skip link, and `prefers-reduced-motion` respected

The legal pages are `noindex, follow` — standard for legal notices, and it keeps
placeholder company details out of the index while they are still placeholders.

## Not built, on purpose

No quote form, no booking widget, no pricing table, no testimonials, no client logos,
no blog, no keyword pages. The site is the link sent after a conversation has already
started; its only job is to make a gatekeeper comfortable putting their own name behind
this supplier. One email address is the entire call to action.

A French version at `/fr/` is planned — written natively, not machine-translated. When
it lands, add `hreflang` alternates to both pages and a second `<url>` to the sitemap.
