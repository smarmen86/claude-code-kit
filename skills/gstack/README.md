# gstack shared runtime

This directory is the mount point for the **gstack** shared runtime that the gstack skills
(`autoplan`, `review`, `qa`, `ship`, `browse`, etc.) call into — e.g.
`~/.claude/skills/gstack/bin/gstack-update-check`.

It is **not itself a skill** (it has no `SKILL.md`), so it is not counted in the skill total.

> **Note:** earlier revisions committed this path as a dangling git submodule (a `160000`
> gitlink with no `.gitmodules`), which made `git clone` / `git submodule update` land it as an
> empty, broken directory. It is now a plain tracked directory. The gstack skills guard their
> calls into it (`... || true`), so they degrade gracefully when the runtime binaries aren't
> present; install gstack separately if you want the update-check / session tooling.
