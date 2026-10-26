# KIT as a Custom GPT (no-code)

ChatGPT has **no bulk import** for Custom GPTs and caps instructions at 8,000 chars with 20
knowledge files. So this build ships **one router GPT** whose knowledge files hold all
276 personas; the GPT adopts the right one per task.

## Build it (one-time, ~5 min)

1. ChatGPT → **Explore GPTs → Create → Configure**.
2. **Name:** `Klugman IT KIT`  ·  **Description:** `276 specialist personas behind one router.`
3. **Instructions:** paste all of `custom-gpt/instructions.md`.
4. **Conversation starters:** copy the 4 from `custom-gpt/conversation-starters.md`.
5. **Knowledge:** upload every file in `custom-gpt/knowledge/` (20 files — within the 20 cap):
- `knowledge/education-academic.md` — Education & Academic (12)
- `knowledge/finance.md` — Finance (12)
- `knowledge/specialized.md` — Specialized (17)
- `knowledge/engineering.md` — Engineering (40)
- `knowledge/sales.md` — Sales (13)
- `knowledge/blog.md` — Blog & Content (5)
- `knowledge/creative.md` — Creative (8)
- `knowledge/healthcare.md` — Healthcare (6)
- `knowledge/marketing.md` — Marketing (20)
- `knowledge/testing-qa.md` — Testing & QA (9)
- `knowledge/support-ops.md` — Support & Operations (17)
- `knowledge/data-ai.md` — Data & AI (13)
- `knowledge/design-ux.md` — Design & UX (8)
- `knowledge/ecommerce-industry.md` — E-commerce & Industry (13)
- `knowledge/china-marketing.md` — China Marketing (20)
- `knowledge/gamedev-xr.md` — Game Dev & XR (24)
- `knowledge/legal.md` — Legal (3)
- `knowledge/paid-media.md` — Paid Media (7)
- `knowledge/product-pm.md` — Product & Project Management (11)
- `knowledge/seo.md` — SEO (18)
6. **Capabilities:** leave Web Search on; Code Interpreter optional.
7. **Save** (Only me / Anyone with link / Published — your call).

## Why packs, not 276 files

20-file cap + RAG retrieval favors a few well-structured prose files. Each persona is a
`## PERSONA:` block with keywords, so semantic search surfaces the right one.

## Want it programmatic instead?

See `../agents-sdk/` — a Responses-API router that instantiates personas from `personas.json`.
(The Assistants API sunsets 2026-08-26; this build targets the Responses API + Agents SDK.)
