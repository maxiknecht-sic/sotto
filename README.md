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
img/                photography (see below) — currently empty
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

## Adding the photography

Six slots, all driven by CSS variables at the top of `index.html`:

```css
:root{
  --img-hero:none;        /* Yacht deck at dusk, low light, wide         */
  --img-yachts:none;      /* Coffee served on deck, daylight            */
  --img-parties:none;     /* Villa terrace or poolside, evening, guests */
  --img-sport:none;       /* Golf or paddock hospitality, daytime       */
  --img-crew:none;        /* Barista at work, hands and machine, close  */
  --img-night:none;       /* Espresso martinis on the bar, after dark   */
}
```

Drop the file in `/img/` and point the variable at it:

```css
--img-hero:url("/img/hero.jpg");
```

Left as `none`, the slot renders as a tonal band with a small caption describing the
shot. That is the current state: no broken images, nothing that looks unfinished, but
the page is visibly waiting for its photography.

Rules from the brief: nothing with visible logos, recognisable faces, or editorial-only
sports licensing. Export at 1600 px wide, WebP with a JPEG fallback, and keep each file
under about 60 KB — the hero under 100 KB.

## Weight

First load is the HTML plus two font files. Everything else is cached for a year.

| | |
|---|---|
| `index.html` (markup + all CSS) | ~17 KB |
| `newsreader-latin.woff2` | ~129 KB |
| `schibsted-grotesk-latin.woff2` | ~46 KB |
| **Total, no photography** | **~192 KB** |

The `latin-ext` font files ship too but are only fetched if a page actually uses an
Eastern European character, because each `@font-face` carries a `unicode-range`. They
cost nothing on a normal visit.

Adding all six photographs at the sizes above lands around 450 KB — still inside budget,
and only the hero loads before the fold.

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
