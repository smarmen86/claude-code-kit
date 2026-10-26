"""
KIT router — OpenAI Responses API.

Loads 276 specialist personas from personas.json, picks the best one for a
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
    menu = "\n".join(f'- {p["slug"]}: {p["name"]} — {p["description"]}' for p in shortlist)
    r = client.responses.create(
        model=MODEL,
        input=[
            {"role": "system", "content":
                "Pick the single best specialist slug for the task. Reply with ONLY the slug."},
            {"role": "user", "content": f"Task: {task}\n\nSpecialists:\n{menu}"},
        ],
    )
    slug = r.output_text.strip().split()[0].strip("`.,")
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
    print(f"\n>>> Acting as: {persona['name']} ({persona['slug']})\n", file=sys.stderr)
    print(run(task, persona))


if __name__ == "__main__":
    main()
