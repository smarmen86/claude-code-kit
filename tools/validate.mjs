#!/usr/bin/env node
// validate.mjs — integrity checks for the kit. Exits non-zero on hard errors so CI fails.
//   node tools/validate.mjs
//
// Checks: every agent has name+description; no duplicate names; every skills/* dir has a
// SKILL.md; README counts match reality.

import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { readdirSync, readFileSync, existsSync } from "node:fs";
import { loadAgents } from "./lib/parse.mjs";

const REPO = join(dirname(fileURLToPath(import.meta.url)), "..");
const errors = [];
const warnings = [];

// --- Agents ---
const agents = loadAgents(join(REPO, "agents"));
const names = new Map();
for (const a of agents) {
  if (!a.name) errors.push(`${a.slug}: missing frontmatter 'name'`);
  if (!a.description) errors.push(`${a.slug}: missing frontmatter 'description'`);
  if (a.body.length < 50) warnings.push(`${a.slug}: very short body (${a.body.length} chars)`);
  const key = a.name.toLowerCase();
  if (names.has(key)) errors.push(`duplicate agent name "${a.name}": ${names.get(key)} & ${a.slug}`);
  else names.set(key, a.slug);
  // Disallowed control chars (not \t \n \r) break TOML generation and pollute knowledge packs.
  const ctrl = a.raw.match(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/);
  if (ctrl) {
    errors.push(`${a.slug}: contains control char \\x${ctrl[0].charCodeAt(0).toString(16).padStart(2, "0")}`);
  }
}

// --- Skills ---
const skillsDir = join(REPO, "skills");
// Directories that live under skills/ but are not themselves skills (shared runtime).
const SUPPORT_DIRS = new Set(["gstack"]);
let skillCount = 0;
const emptySkillDirs = [];
for (const d of readdirSync(skillsDir, { withFileTypes: true })) {
  if (!d.isDirectory()) continue;
  if (existsSync(join(skillsDir, d.name, "SKILL.md"))) skillCount++;
  else if (!d.name.startsWith("_") && !SUPPORT_DIRS.has(d.name)) emptySkillDirs.push(d.name);
}
for (const d of emptySkillDirs) warnings.push(`skills/${d}/: no SKILL.md (empty or stray dir)`);

// --- README counts match reality ---
const readme = readFileSync(join(REPO, "README.md"), "utf8");
function checkCount(label, actual) {
  // Find "<number> <label>" mentions and verify they equal `actual`.
  const re = new RegExp(`(\\d+)\\s+${label}`, "gi");
  let m;
  const bad = new Set();
  while ((m = re.exec(readme))) {
    if (Number(m[1]) !== actual) bad.add(m[1]);
  }
  for (const n of bad) errors.push(`README says "${n} ${label}" but actual is ${actual}`);
}
checkCount("agents", agents.length);
checkCount("skills", skillCount);

// --- Report ---
console.log(`Agents: ${agents.length} · Skills (with SKILL.md): ${skillCount}`);
for (const w of warnings) console.log(`  warn: ${w}`);
if (errors.length) {
  console.error(`\n${errors.length} error(s):`);
  for (const e of errors) console.error(`  ERROR: ${e}`);
  process.exit(1);
}
console.log(`OK — no errors${warnings.length ? ` (${warnings.length} warning(s))` : ""}.`);
