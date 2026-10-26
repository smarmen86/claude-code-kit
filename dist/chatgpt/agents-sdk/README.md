# KIT via the OpenAI Responses API / Agents SDK

Programmatic path: all 276 personas in `personas.json`, routed and run by
`router.py` on the **Responses API** (the Assistants API sunsets 2026-08-26).

```bash
pip install -r requirements.txt
export OPENAI_API_KEY=sk-...
python router.py "design a scalable payments API"
python router.py --persona finance-tax-strategist "optimize my SaaS entity structure"
```

- `personas.json` — generated registry: slug, name, category, keywords, description, instructions.
- `router.py` — keyword prefilter → model triage → run chosen persona.

### Scaling up
For a full handoff graph (a triage agent delegating to specialist agents with the Agents SDK's
`handoffs=`), load `personas.json` and construct one `Agent` per persona. The lean router here
avoids instantiating 276 agents up front and is cheaper for one-shot tasks.
