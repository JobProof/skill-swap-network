# Skill Swap Network

Local skill swap network — a task-for-task barter platform where neighbors trade help hour-for-hour instead of paying cash.

## What's in this repo

- `index.html` — the home page (self-contained: HTML + CSS, no build step)
- `schema.sql` — the full database design (users, needs, offers, swaps, messages, photos, confirmations, reviews)

## How to preview

### Option 1: Local (private)

1. Clone the repo or download `index.html`
2. Double-click `index.html` — it opens in your browser

No server, no install, no build needed.

### Option 2: GitHub Pages (live URL)

1. Go to **Settings → Pages** on this repo
2. Under "Build and deployment", set **Source** to **Deploy from a branch**
3. Set branch to **main**, folder to **/ (root)**, then **Save**
4. Wait 1–2 minutes, then open `https://jobproof.github.io/skill-swap-network/`

## Roadmap

- [ ] Sign-up / profiles tied to the `users` table
- [ ] Post needs and offers
- [ ] Swap proposals with hour credits
- [ ] Messaging and proof photos
- [ ] Reviews after completed swaps
