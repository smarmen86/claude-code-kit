#!/usr/bin/env node
// build.mjs — generate the Codex and ChatGPT builds (and manifest/catalog) from the
// single source of truth: agents/*.md + skills/*/SKILL.md + CLAUDE.md at the repo root.
//
//   node tools/build.mjs            # build everything
//   node tools/build.mjs codex      # just Codex
//   node tools/build.mjs chatgpt    # just ChatGPT
//   node tools/build.mjs manifest   # just manifest.json + CATALOG.md
//
// Claude Code IS the source tree (root agents/ + skills/), so there's no separate
// "claude" build — the manifest/catalog describe it.

import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { loadAgents, loadSkills } from "./lib/parse.mjs";
import { classify, CATEGORIES } from "./lib/categories.mjs";
import { cleanDir } from "./lib/util.mjs";
import { buildCodex } from "./lib/targets/codex.mjs";
import { buildChatGPT } from "./lib/targets/chatgpt.mjs";
import { buildManifest } from "./lib/targets/manifest.mjs";

const REPO = join(dirname(fileURLToPath(import.meta.url)), "..");

function buildModel() {
  const agents = loadAgents(join(REPO, "agents")).map((a) => ({
    ...a,
    category: classify(a),
  }));
  const skills = loadSkills(join(REPO, "skills"));

  // Group into categories in the canonical CATEGORIES order; keep only non-empty.
  const categories = CATEGORIES
    .map((name) => ({ name, agents: agents.filter((a) => a.category === name) }))
    .filter((c) => c.agents.length > 0);

  return {
    agents,
    skills,
    categories,
    counts: {
      agents: agents.length,
      skills: skills.length,
      categories: categories.length,
    },
  };
}

function main() {
  const target = (process.argv[2] || "all").toLowerCase();
  const model = buildModel();
  console.log(
    `Loaded ${model.counts.agents} agents, ${model.counts.skills} skills, ` +
    `${model.counts.categories} categories.`
  );

  if (target === "all" || target === "manifest") {
    buildManifest(model, REPO);
    console.log("✓ manifest.json + CATALOG.md");
  }
  if (target === "all" || target === "codex") {
    const dir = join(REPO, "dist", "codex");
    cleanDir(dir);
    const r = buildCodex(model, dir);
    console.log(`✓ dist/codex (${r.agentFiles} subagents)`);
  }
  if (target === "all" || target === "chatgpt") {
    const dir = join(REPO, "dist", "chatgpt");
    cleanDir(dir);
    const r = buildChatGPT(model, dir);
    const flag = r.instructionChars <= r.instructionLimit ? "✓" : "✗ OVER LIMIT";
    console.log(
      `✓ dist/chatgpt (${r.packs} knowledge packs; ` +
      `router instructions ${r.instructionChars}/${r.instructionLimit} chars ${flag})`
    );
    if (r.instructionChars > r.instructionLimit) process.exitCode = 1;
  }
  if (!["all", "codex", "chatgpt", "manifest"].includes(target)) {
    console.error(`Unknown target: ${target}. Use: all | codex | chatgpt | manifest`);
    process.exitCode = 2;
  }
}

main();
