// parse.mjs — read agents/*.md and parse YAML frontmatter + markdown body.
// Zero dependencies. The frontmatter in this repo is flat `key: value` (single line
// values), so a full YAML parser is unnecessary — we parse defensively.

import { readdirSync, readFileSync } from "node:fs";
import { join, basename } from "node:path";

/** Split a markdown file into { frontmatter: {...}, body: "..." }. */
export function splitFrontmatter(raw) {
  const text = raw.replace(/^﻿/, ""); // strip BOM
  if (!text.startsWith("---")) return { frontmatter: {}, body: text.trim() };
  // Find the closing --- on its own line after the opening one.
  const lines = text.split(/\r?\n/);
  let end = -1;
  for (let i = 1; i < lines.length; i++) {
    if (lines[i].trim() === "---") { end = i; break; }
  }
  if (end === -1) return { frontmatter: {}, body: text.trim() };

  const fm = {};
  for (let i = 1; i < end; i++) {
    const line = lines[i];
    if (!line.trim() || line.trim().startsWith("#")) continue;
    const m = line.match(/^([A-Za-z_][\w-]*):\s?(.*)$/);
    if (!m) continue;
    let [, key, val] = m;
    val = val.trim();
    // strip matching surrounding quotes
    if ((val.startsWith('"') && val.endsWith('"')) ||
        (val.startsWith("'") && val.endsWith("'"))) {
      val = val.slice(1, -1);
    }
    fm[key] = val;
  }
  const body = lines.slice(end + 1).join("\n").trim();
  return { frontmatter: fm, body };
}

/** Read one agent file into a normalized record. */
export function parseAgentFile(filePath) {
  const raw = readFileSync(filePath, "utf8");
  const { frontmatter, body } = splitFrontmatter(raw);
  const slug = basename(filePath, ".md");
  return {
    slug,
    name: frontmatter.name || slug,
    description: (frontmatter.description || "").trim(),
    color: frontmatter.color || "",
    emoji: frontmatter.emoji || "",
    vibe: frontmatter.vibe || "",
    model: frontmatter.model || "",
    tools: frontmatter.tools || "",
    body,
    raw,
  };
}

/** Read every agent under agents/ (sorted by slug). */
export function loadAgents(agentsDir) {
  return readdirSync(agentsDir)
    .filter((f) => f.endsWith(".md"))
    .sort()
    .map((f) => parseAgentFile(join(agentsDir, f)));
}

/** List skill directories that contain a SKILL.md (sorted). */
export function loadSkills(skillsDir) {
  const out = [];
  for (const d of readdirSync(skillsDir, { withFileTypes: true })) {
    if (!d.isDirectory()) continue;
    let hasSkill = false;
    try {
      hasSkill = readdirSync(join(skillsDir, d.name)).includes("SKILL.md");
    } catch { /* unreadable */ }
    if (hasSkill) out.push(d.name);
  }
  return out.sort();
}
