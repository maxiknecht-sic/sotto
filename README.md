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
img/                photography, WebP + JPEG (interim stock — see below)
robots.txt          allows everything, points at the sitemap
sitemap.xml         one URL, the homepage
vercel.json         static config, caching and security headers
scripts/configure.sh  sets the domain and email across every file
```

## Before launch

Two values are placeholders and must be replaced. One command does both:

```bash
./scripts/configure.sh --domain sotto.com --email hello@sotto.com
```

That rewrites the canonical, the Open Graph URLs, the JSON-LD, `robots.txt`,
`sitemap.xml` and every `mailto:` link, then lists whatever is still outstanding.

The remaining placeholders are company facts nobody can invent for you. They are marked
in the HTML with `class="todo"` and render on a **yellow highlight**, so they cannot ship
unnoticed. Find them with:

```bash
grep -rn 'class="todo"' --include='*.html' .
```

They are: the OÜ's legal name, registry code, VAT number, registered address and board
member (in `/legal/`), and the go-live date (in `/privacy/`).

One more: the figures in the **Specifications** table on the homepage are the comp's
placeholder numbers. Measure the real rig and replace them — the table is the part of
this page a chief stewardess will actually read twice.

## The photography

Six slots, all driven by CSS variables at the top of `index.html`. Each one names a
WebP and a JPEG, and `image-set()` lets the browser take whichever it supports:

```css
--img-hero:image-set(url("/img/hero.webp") type("image/webp"),
                     url("/img/hero.jpg")  type("image/jpeg"));
```

**What is in there now is interim stock, and should be replaced.** Five of the six are
public domain (CC0) and need no attribution; the harbour-at-dusk hero is CC BY 2.0 and
is credited on `/legal/` as that licence requires. If you replace it, remove that credit.

Two honest caveats:

- **Resolution.** Only the hero is a full-resolution original (2200 px). The other five
  came from sources that cap free downloads at around 1000 px, so they are served at
  their native size and will look soft on a large display. They are placeholders that
  photograph well at a glance, not finished assets.
- **Subject.** `parties` is the weakest — an infinity pool over wooded hills, which
  reads tropical resort rather than Côte d'Azur. Replace that one first. `yachts` is a
  cappuccino on a table rather than coffee served on a deck.

To replace one, drop `name.webp` and `name.jpg` into `/img/` over the existing pair.
No other change is needed. Export at 2200 px wide for the hero and 1800 px for the
bands, and keep each WebP under about 60 KB — the hero under 100 KB.

Rules from the brief: nothing with visible logos, recognisable faces, or editorial-only
sports licensing. There is no image tooling in this repo; the current set was produced
with `sharp`, e.g.:

```bash
npx sharp-cli -i shot.jpg -o img/parties.webp resize 1800 1013 --fit cover -- webp -q 76
```

## Weight

Everything is cached for a year after the first visit.

| | |
|---|---|
| `index.html` (markup + all CSS) | ~18 KB |
| `newsreader-latin.woff2` | ~129 KB |
| `schibsted-grotesk-latin.woff2` | ~46 KB |
| `hero.webp` (preloaded) | ~82 KB |
| **Above the fold** | **~275 KB** |
| the five band photographs (WebP) | ~163 KB |
| **Whole page** | **~437 KB** |

Measured in the browser, not estimated. Inside the 500 KB budget, with the caveat that
CSS background images are not deferred the way `loading="lazy"` defers an `<img>`, so
the band photographs are fetched on the first visit rather than on scroll.

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
