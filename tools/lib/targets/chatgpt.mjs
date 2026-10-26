// chatgpt.mjs — emit a ChatGPT build from the shared agent model.
//
// Two surfaces (verified against OpenAI docs/limits, 2026):
//   custom-gpt/  — no-code: a router GPT (instructions <= 8,000 chars) + <= 20 consolidated
//                  knowledge packs. Custom GPTs have no bulk import, so the library lives in
//                  knowledge files (RAG) and ONE router GPT adopts the right persona.
//   agents-sdk/  — programmatic: personas.json + a Responses-API router (the Assistants API
//                  sunsets 2026-08-26; Responses API + Agents SDK is the successor).

import { join } from "node:path";
import { write } from "../util.mjs";
import { keywords } from "../util.mjs";

const INSTRUCTION_LIMIT = 8000;

// Collapse 24 categories into <= 20 knowledge packs (Custom GPT caps knowledge at 20 files).
const PACK_MAP = {
  "Engineering": ["engineering", "Engineering"],
  "Testing & QA": ["testing-qa", "Testing & QA"],
  "Design & UX": ["design-ux", "Design & UX"],
  "Marketing": ["marketing", "Marketing"],
  "China Marketing": ["china-marketing", "China Marketing"],
  "Paid Media": ["paid-media", "Paid Media"],
  "SEO": ["seo", "SEO"],
  "Blog": ["blog", "Blog & Content"],
  "Sales": ["sales", "Sales"],
  "Finance": ["finance", "Finance"],
  "Product": ["product-pm", "Product & Project Management"],
  "Project Management": ["product-pm", "Product & Project Management"],
  "Healthcare": ["healthcare", "Healthcare"],
  "Legal": ["legal", "Legal"],
  "Game Dev": ["gamedev-xr", "Game Dev & XR"],
  "XR & Spatial": ["gamedev-xr", "Game Dev & XR"],
  "Data & AI": ["data-ai", "Data & AI"],
  "Education": ["education-academic", "Education & Academic"],
  "Academic": ["education-academic", "Education & Academic"],
  "E-commerce": ["ecommerce-industry", "E-commerce & Industry"],
  "Industry": ["ecommerce-industry", "E-commerce & Industry"],
  "Creative": ["creative", "Creative"],
  "Support & Ops": ["support-ops", "Support & Operations"],
  "Specialized": ["specialized", "Specialized"],
};

function personaBlock(a) {
  return `## PERSONA: ${a.name}
- Slug: \`${a.slug}\`
- Category: ${a.category}
- Keywords: ${keywords(a)}
- Summary: ${a.description}

${a.body}

---
`;
}

function buildPacks(model) {
  // pack slug -> { title, agents: [] }
  const packs = new Map();
  for (const a of model.agents) {
    const [slug, title] = PACK_MAP[a.category] || ["specialized", "Specialized"];
    if (!packs.has(slug)) packs.set(slug, { title, agents: [] });
    packs.get(slug).agents.push(a);
  }
  return packs;
}

function packFile(slug, title, agents) {
  const toc = agents.map((a) => `- ${a.name} (\`${a.slug}\`)`).join("\n");
  const blocks = agents.map(personaBlock).join("\n");
  return `# KIT Knowledge Pack — ${title}

Part of the **Klugman IT KIT** persona library (${agents.length} specialists in this pack).
Each \`## PERSONA:\` section is one specialist. When the user's task matches a persona,
adopt that persona's identity, priorities, and methods for your response.

### Personas in this pack
${toc}

---

${blocks}`;
}

function routerInstructions(model, packs) {
  const { counts } = model;
  const catLine = [...packs.values()]
    .map((p) => `${p.title} (${p.agents.length})`)
    .join(" · ");

  let text = `# Klugman IT KIT — Specialist Router

You are **KIT**, a router in front of ${counts.agents} specialist personas packaged by Klugman IT.
Your knowledge files hold the full persona library, grouped into packs. Each persona appears as a
\`## PERSONA: <name>\` block with a Slug, Category, Keywords, Summary, and a full persona brief.

## How to respond

1. **Identify the task's domain.** Map the user's request to the most relevant persona(s).
2. **Retrieve the persona.** Search your knowledge files for the matching \`## PERSONA:\` block.
   Prefer an exact specialist over a generalist. If two fit, pick the most specific.
3. **Adopt it.** Answer *as* that persona — its identity, priorities, standards, and methods from
   its brief. Open by naming who you've become, e.g. "Acting as **Backend Architect** —".
4. **Multi-domain tasks:** name the 2–4 relevant specialists, then synthesize their perspectives
   into one coherent answer. Don't dump raw personas; integrate them.
5. **No clear match:** act as a thoughtful generalist and say so.

## Rules

- Stay in the adopted persona's lane; defer out loud when a task needs a different specialist.
- Be concrete and actionable. Match the persona's described tone and rigor.
- Never invent a persona that isn't in your knowledge files.
- If asked "who can you be?" or "what specialists exist?", summarize the packs below and offer to route.

## Packs (persona counts)

${catLine}

## Routing hints

- Code/architecture/devops/security → Engineering. Review → code reviewer then simplifier.
- Growth/content/social/ads → Marketing, Paid Media, SEO, Blog. China platforms → China Marketing.
- Selling → Sales. Money → Finance. Shipping product → Product & Project Management.
- Data/ML/AI/RAG/SQL → Data & AI. Pixels → Design & UX. Tests → Testing & QA.
- Games/engines/XR → Game Dev & XR. Regulated work → Healthcare, Legal.
- Teaching → Education & Academic. Stores/ops/industry → E-commerce & Industry, Support & Operations.
- Orchestration, MCP, Salesforce, civil eng, misc → Specialized.
`;

  // Enforce the 8,000-char cap. If over, drop the two most verbose sections.
  if (text.length > INSTRUCTION_LIMIT) {
    text = text.replace(/\n## Routing hints[\s\S]*$/, "\n");
  }
  if (text.length > INSTRUCTION_LIMIT) {
    text = text.slice(0, INSTRUCTION_LIMIT - 1);
  }
  return text;
}

function conversationStarters() {
  return `# Conversation starters (ChatGPT shows up to 4)

Set these in the GPT Builder's "Conversation starters" fields:

1. What specialists can you route me to?
2. Act as the right specialist to review my backend architecture.
3. Build me a go-to-market plan — pull in the marketing, SEO, and sales specialists.
4. I have a multi-step project. Orchestrate the right specialists for it.
`;
}

function gptReadme(model, packs) {
  const packList = [...packs.entries()]
    .map(([slug, p]) => `- \`knowledge/${slug}.md\` — ${p.title} (${p.agents.length})`)
    .join("\n");
  return `# KIT as a Custom GPT (no-code)

ChatGPT has **no bulk import** for Custom GPTs and caps instructions at 8,000 chars with 20
knowledge files. So this build ships **one router GPT** whose knowledge files hold all
${model.counts.agents} personas; the GPT adopts the right one per task.

## Build it (one-time, ~5 min)

1. ChatGPT → **Explore GPTs → Create → Configure**.
2. **Name:** \`Klugman IT KIT\`  ·  **Description:** \`${model.counts.agents} specialist personas behind one router.\`
3. **Instructions:** paste all of \`custom-gpt/instructions.md\`.
4. **Conversation starters:** copy the 4 from \`custom-gpt/conversation-starters.md\`.
5. **Knowledge:** upload every file in \`custom-gpt/knowledge/\` (${packs.size} files — within the 20 cap):
${packList}
6. **Capabilities:** leave Web Search on; Code Interpreter optional.
7. **Save** (Only me / Anyone with link / Published — your call).

## Why packs, not 276 files

20-file cap + RAG retrieval favors a few well-structured prose files. Each persona is a
\`## PERSONA:\` block with keywords, so semantic search surfaces the right one.

## Want it programmatic instead?

See \`../agents-sdk/\` — a Responses-API router that instantiates personas from \`personas.json\`.
(The Assistants API sunsets 2026-08-26; this build targets the Responses API + Agents SDK.)
`;
}

// ---- Agents SDK / Responses API package ----

function personasJson(model) {
  const out = model.agents.map((a) => ({
    slug: a.slug,
    name: a.name,
    category: a.category,
    keywords: keywords(a),
    description: a.description,
    instructions: `You are ${a.name}.${a.vibe ? " " + a.vibe : ""}\n\n${a.body}`,
  }));
  return JSON.stringify(out, null, 2) + "\n";
}

function routerPy(model) {
  return `"""
KIT router — OpenAI Responses API.

Loads ${model.counts.agents} specialist personas from personas.json, picks the best one for a
task (keyword prefilter + a lightweight model triage), and runs the chosen persona.

The Assistants API sunsets 2026-08-26; this uses the Responses API (its successor). For a
full multi-agent handoff graph, see the OpenAI Agents SDK — this router is the lean version.

Usage:
    pip install -r requirements.txt
    export OPENAI_API_KEY=sk-...
    python router.py "design a scalable payments API"
    python router.py --persona engineering-backend-architect "design a payments API"
"""
import argparse, json, os, sys
from pathlib import Path
from openai import OpenAI

MODEL = os.environ.get("KIT_MODEL", "gpt-5.1")
PERSONAS = json.loads((Path(__file__).parent / "personas.json").read_text(encoding="utf-8"))
BY_SLUG = {p["slug"]: p for p in PERSONAS}
client = OpenAI()


def prefilter(task, k=12):
    """Cheap keyword overlap to shortlist candidate personas before triage."""
    words = {w for w in task.lower().replace("/", " ").split() if len(w) > 3}
    scored = []
    for p in PERSONAS:
        hay = (p["keywords"] + " " + p["description"] + " " + p["category"]).lower()
        scored.append((sum(1 for w in words if w in hay), p))
    scored.sort(key=lambda t: t[0], reverse=True)
    top = [p for s, p in scored if s > 0][:k]
    return top or PERSONAS[:k]


def choose(task):
    """Ask the model to pick one persona slug from the shortlist."""
    shortlist = prefilter(task)
    menu = "\\n".join(f'- {p["slug"]}: {p["name"]} — {p["description"]}' for p in shortlist)
    r = client.responses.create(
        model=MODEL,
        input=[
            {"role": "system", "content":
                "Pick the single best specialist slug for the task. Reply with ONLY the slug."},
            {"role": "user", "content": f"Task: {task}\\n\\nSpecialists:\\n{menu}"},
        ],
    )
    slug = r.output_text.strip().split()[0].strip("\`.,")
    return BY_SLUG.get(slug, shortlist[0])


def run(task, persona):
    r = client.responses.create(
        model=MODEL,
        instructions=persona["instructions"],
        input=task,
    )
    return r.output_text


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("task", nargs="+")
    ap.add_argument("--persona", help="force a persona slug (skip routing)")
    args = ap.parse_args()
    task = " ".join(args.task)
    persona = BY_SLUG[args.persona] if args.persona else choose(task)
    if args.persona and not persona:
        sys.exit(f"Unknown persona: {args.persona}")
    print(f"\\n>>> Acting as: {persona['name']} ({persona['slug']})\\n", file=sys.stderr)
    print(run(task, persona))


if __name__ == "__main__":
    main()
`;
}

function sdkReadme(model) {
  return `# KIT via the OpenAI Responses API / Agents SDK

Programmatic path: all ${model.counts.agents} personas in \`personas.json\`, routed and run by
\`router.py\` on the **Responses API** (the Assistants API sunsets 2026-08-26).

\`\`\`bash
pip install -r requirements.txt
export OPENAI_API_KEY=sk-...
python router.py "design a scalable payments API"
python router.py --persona finance-tax-strategist "optimize my SaaS entity structure"
\`\`\`

- \`personas.json\` — generated registry: slug, name, category, keywords, description, instructions.
- \`router.py\` — keyword prefilter → model triage → run chosen persona.

### Scaling up
For a full handoff graph (a triage agent delegating to specialist agents with the Agents SDK's
\`handoffs=\`), load \`personas.json\` and construct one \`Agent\` per persona. The lean router here
avoids instantiating ${model.counts.agents} agents up front and is cheaper for one-shot tasks.
`;
}

function requirements() {
  return "openai>=1.60.0\n";
}

export function buildChatGPT(model, outDir) {
  const packs = buildPacks(model);

  // custom-gpt
  for (const [slug, p] of packs) {
    write(join(outDir, "custom-gpt", "knowledge", `${slug}.md`), packFile(slug, p.title, p.agents));
  }
  const instr = routerInstructions(model, packs);
  write(join(outDir, "custom-gpt", "instructions.md"), instr);
  write(join(outDir, "custom-gpt", "conversation-starters.md"), conversationStarters());
  write(join(outDir, "custom-gpt", "README.md"), gptReadme(model, packs));

  // agents-sdk
  write(join(outDir, "agents-sdk", "personas.json"), personasJson(model));
  write(join(outDir, "agents-sdk", "router.py"), routerPy(model));
  write(join(outDir, "agents-sdk", "requirements.txt"), requirements());
  write(join(outDir, "agents-sdk", "README.md"), sdkReadme(model));

  return {
    packs: packs.size,
    instructionChars: instr.length,
    instructionLimit: INSTRUCTION_LIMIT,
  };
}
