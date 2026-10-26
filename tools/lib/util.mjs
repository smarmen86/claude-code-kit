// util.mjs — small filesystem + string helpers shared by the generators.
import { mkdirSync, writeFileSync, rmSync, existsSync } from "node:fs";
import { dirname } from "node:path";

/** Write a file, creating parent dirs. Returns the content length. */
export function write(path, content) {
  mkdirSync(dirname(path), { recursive: true });
  writeFileSync(path, content, "utf8");
  return content.length;
}

/** Remove a directory tree if it exists (used to give each build a clean slate). */
export function cleanDir(path) {
  if (existsSync(path)) rmSync(path, { recursive: true, force: true });
  mkdirSync(path, { recursive: true });
}

/** "engineering-backend-architect" -> "engineering backend architect". */
export function deslug(slug) {
  return slug.replace(/[-_]+/g, " ").trim();
}

/** Derive a few search keywords/aliases from a slug + name (for RAG retrieval). */
export function keywords(agent) {
  const words = new Set();
  for (const w of `${agent.slug} ${agent.name}`.toLowerCase().split(/[^a-z0-9]+/)) {
    if (w.length > 2) words.add(w);
  }
  return [...words].join(", ");
}

/** First sentence of a description, for compact listings. */
export function firstSentence(text) {
  const m = (text || "").match(/^.*?[.!?](\s|$)/);
  return (m ? m[0] : text || "").trim();
}
