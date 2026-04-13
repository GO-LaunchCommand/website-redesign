# GO Journal — Claude Code Session Guide

This file is automatically loaded every time a Claude Code session opens in this folder.
It gives Claude everything needed to help Kym write, polish, and publish GO Journal articles.

---

## What This Project Is

**Gymnastics Online (GO)** is a platform for gymnastics parents — built by Kym Volp, a gymnastics
performance coach and club director. The GO Journal is the editorial heart of the brand: expert-backed
articles that help parents understand what's actually happening in the gym, and feel less alone doing it.

**Kym's publishing workflow:**
1. ChatGPT produces a rough draft
2. Kym brings it into a CC session (here) to polish it into GO's voice
3. CC publishes it directly to WordPress via the REST API

When Kym says **"new post"** or **"polish this draft"** — run through the
[New Post Checklist](#new-post-checklist) below.

---

## The Reader

Every article is written for **one specific person**: a parent (usually a mother) of a competitive
junior gymnast, aged roughly 6–14. She:

- Loves the sport but finds it confusing, expensive, and emotionally loaded
- Feels she can't always ask the coach without seeming like "that parent"
- Wants to understand what's happening — not be told what to do
- Is time-poor and reads on her phone, usually at training or in the car park
- Feels relieved when someone finally says out loud what she's been quietly thinking

Write *to* her. Not *at* her.

---

## GO Voice & Style Guide

### The non-negotiables

**1. Open with her experience, not the topic.**
Every article starts by putting the reader inside a moment she recognises — before naming the topic.

> ✅ "If you're a gymnastics parent, chances are the costs didn't fully reveal themselves on day one."
> ✅ "If your child could once do a skill confidently and now can't, it can feel unsettling."
> ✅ "If you've ever watched your child compete and felt completely confused when the scores appeared..."

Never open with a definition, a statistic, or a declarative statement about the topic.

**2. Validate before explaining.**
After the opening scenario, the second or third paragraph always acknowledges her experience directly.

> ✅ "You're not imagining it, and you're far from alone."
> ✅ "Many parents quietly wonder the same thing."
> ✅ "That feeling is real — and it makes complete sense."

**3. Short paragraphs. Always.**
Maximum 3 sentences per paragraph. Most are 1–2. This is not negotiable — the reader is on her phone.

**4. Evidence-based but never clinical.**
GO references research and science, but always translates it immediately into plain language.
Use **Parent Translation:** callout boxes (see below) to bridge the gap.

**5. Warm, not soft.**
GO is honest. It doesn't sugarcoat hard realities (cost, burnout, fear, coach tension). But it holds
the reader gently through those realities rather than alarming her.

**6. Never preachy. Never prescriptive.**
Avoid: "You should...", "Parents must...", "It's important to remember..."
Prefer: "Many families find...", "It can help to...", "One thing worth knowing..."

---

### Tone words
Warm. Honest. Grounded. Expert. Reassuring. Real.

### Words GO uses
quietly, genuinely, sustainable, steadier, clarity, real, often, many families, you're not alone,
it makes sense, from a scientific standpoint, evidence shows, coach insight, parent translation

### Words GO avoids
amazing, incredible, game-changer, empower, journey (as a verb), holistic, transformative,
just (minimising), simply (condescending), obviously, clearly

---

## Post Structure

Every GO article follows this structure. Adapt proportions to the topic — don't force all elements
into every post — but the opening, Parent Translations, closing, and CTA are always present.

```
OPENING (no heading)
  — Parent-experience scenario (2–3 short paragraphs)
  — Validation statement
  — What this article will cover (1 sentence, not a bullet list)

H2: [First topic section]
  — Explanation in plain language
  — **Parent Translation:** [1–2 sentence plain-English summary in bold]

H2: [Second topic section]
  ...repeat pattern...

  **Coach Insight Moment: [Short title]**  ← use when Kym's expert POV adds value
  [2–4 paragraphs from the coach's perspective]

H2: [Practical section — what parents can do]
  — Short bullet lists are fine here
  — Specific, actionable, non-prescriptive

H2: FAQs About [Topic]
  — 3–5 questions parents actually ask
  — Short, direct answers (2–4 sentences each)

CLOSING (no heading, 1–3 paragraphs)
  — Warm, reassuring, never preachy
  — Validates that the reader is doing the right thing by staying informed

FINAL LINE (always)
  "Gymnastics Online is being built to support parents through the realities of the sport —
   with clear guidance, expert insight, and a community that understands what this journey
   really looks like."
  [Vary the wording slightly each post but keep the meaning]

CTA BUTTON
  — Added automatically by the WordPress template (single.php)
  — Standard: "Be Part of the Inner Circle →" → links to /home/#early-access
  — Override only if Kym specifies a different CTA for a specific post
```

---

### The two callout elements

**Parent Translation:** — used when scientific or technical content needs simplifying.
Always bold. Always immediately follows the technical paragraph it explains.

```
**Parent Translation:**
Her body is temporarily harder to control, even though she understands the skill perfectly.
```

**Coach Insight Moment:** — used when Kym's expert coaching perspective adds something
a parent can't get from googling. Give it a descriptive subtitle.

```
**Coach Insight Moment: When 'it feels different' is actually real**
[2–4 paragraphs from the coach's POV]
```

---

## Categories & Tags

### WordPress categories (use exact names)
- `Gymnastics Foundations` — technique, judging, skill progression, levels, what happens in the gym
- `Supporting Your Gymnast` — home practice, equipment, parent behaviour, competition support
- `Health, Growth & Wellbeing` — growth, puberty, mental health, cost, burnout, coach relationships

### Tags — common existing tags
competition, scoring, judging, junior gymnastics, ALP levels, skill regression, growth, puberty,
beam, bars, vault, floor, kip, home practice, equipment, burnout, mental health, gymnastics costs,
leotards, parent guide, coach relationship, gymnastics foundations, supporting your gymnast

Create new tags freely — the API handles it automatically.

---

## Standard CTA (bottom of every post)

The WordPress template (`single.php`) automatically appends a CTA section to every post.
**Kym does not need to write this** — it's injected by the theme.

Default CTA: **"Be Part of the Inner Circle →"** → `gymnasticsonline.com/home/#early-access`

If Kym wants a different CTA for a specific post, she tells Claude and it gets added as a custom
HTML block at the bottom of the post content before publishing.

---

## Image Guidelines

**Hero image:**
- Landscape, minimum 1200×675px (16:9 ratio preferred)
- Real gymnastics photography — training, competition, candid parent moments
- No watermarks, no cheesy stock photos with exaggerated poses
- Warm, natural tones that complement the GO palette (deep navy/dark, pink accents)
- Alt text: descriptive, includes the post topic and setting (e.g. "junior gymnast training on beam")

**In-body images:**
- Use sparingly — GO posts are primarily text-led
- If used: full-width, always with descriptive alt text
- Uploaded via WP media library (CC handles this via the REST API)

---

## New Post Checklist

When Kym says **"new post"**, **"new blog"**, or **"polish this draft"**, work through these
questions conversationally — don't present them all at once as a form. Ask 1–2 at a time,
naturally, and adapt based on what she's already told you.

```
1. What's the topic? (If she has a ChatGPT draft, ask her to paste it)
2. Working title — suggest one based on the GO title pattern, ask if she wants to adjust
3. Category — suggest the best fit, confirm
4. Key points to cover (if no draft exists)
5. Tone notes — anything specific for this post? (e.g. "more reassuring", "include more science")
6. Hero image — filename (she drops it in this folder) or she'll add it in WP later
7. Any in-body images?
8. CTA — standard "Inner Circle" or something different for this post?
9. Tags — suggest 4–6 based on the topic, ask if she wants to add any
10. Excerpt — write one based on the content, confirm with her (1–2 sentences, punchy)
11. Publish now, save as draft, or schedule?
```

Once all answered: write or polish the full article, confirm with Kym, then publish via the
script below.

---

## WordPress Publishing

### Credentials setup (one-time, Kym's machine)

Credentials are stored as environment variables — never hardcoded in any file.

Kym sets these once in her shell profile (`~/.zshrc` or `~/.bashrc`):
```bash
export GO_WP_URL="https://gymnasticsonline.com"
export GO_WP_USER="kym"
export GO_WP_PASS="xxxx xxxx xxxx xxxx xxxx xxxx"
```
Then runs `source ~/.zshrc` (or restarts Terminal).

### Publishing a post

Use the `wp-publish.sh` script in this folder:

```bash
# Create new draft
bash wp-publish.sh \
  --title "Your Article Title" \
  --content-file post-content.html \
  --category 5 \
  --tags "competition,scoring,parents" \
  --image hero-image.jpg \
  --status draft

# Publish immediately
bash wp-publish.sh ... --status publish

# Update existing post
bash wp-publish.sh ... --post-id 123
```

The script returns the post URL when done.

### Finding category IDs

If unsure of a category ID, run:
```bash
curl -s "$GO_WP_URL/wp-json/wp/v2/categories" \
  -u "$GO_WP_USER:$GO_WP_PASS" | \
  python3 -c "import sys,json; [print(c['id'], c['name']) for c in json.load(sys.stdin)]"
```

---

## Kym's Folder

When publishing, Claude writes the article content to a temporary `post-content.html` file
in this folder, then calls `wp-publish.sh`. Both files are cleaned up after publishing.

If Kym drops a hero image into this folder, reference it by filename when running the script.

---

## Quick Reference

| Thing | Detail |
|---|---|
| Site | gymnasticsonline.com |
| Author | Kym Volp |
| Default CTA | "Be Part of the Inner Circle →" → /home/#early-access |
| Post template | single.php (in go-child theme) |
| Min hero image | 1200×675px |
| Excerpt length | 1–2 sentences, ~40 words |
| Avg post length | 1,200–2,500 words |
| Opening pattern | "If you're a gymnastics parent..." / "If your child..." |
| Always ends with | GO mission line + automatic CTA button |
