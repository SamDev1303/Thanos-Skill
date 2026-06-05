---
name: context-graph
purpose: Build a structural map of the codebase so REALITY is richer and cheaper than dumping files.
triggers: understand this codebase, where is X defined, map the architecture, how do these modules connect, large repo context
requires: graph
---

# 🕸️ Context Graph

> The REALITY stone reads files — but on a large repo, dumping raw file contents is expensive and
> low-signal. A *structure graph* (who imports whom, where things are defined, how modules cluster)
> gives the agent more understanding per token. This skill is about getting the right context, not
> all of it.

Original best-practice guidance. Inspiration credited in `docs/CREDITS.md`; no upstream code reused.

## When to mobilize

- The repo is too large to read every file into REALITY.
- The goal is "understand / refactor / trace" rather than a single localized edit.
- You keep re-reading the same files because you can't see how pieces connect.

## What a good context graph captures

1. **Nodes = meaningful units** (files/modules, optionally exported symbols), not every line.
2. **Edges = real relationships**: imports/requires, route→handler, test→subject.
3. **Clusters**: directories or domains that move together — the natural seams for change.
4. **Entry points & hubs**: the files everything depends on (touch carefully) and the leaves
   (safe to change).

## How to use it (cheaper, richer REALITY)

1. Run `tools/graph.sh` to emit `.thanos/proof/context-graph.{json,md}` — an import/structure map.
2. Put the **graph summary** into REALITY (or reference it), not the full file dump. Read full
   contents only for the handful of nodes the goal actually touches.
3. Use the graph to scope: "this change touches the auth cluster and its 3 dependents" — that's your
   in/out-of-scope list for SOUL.md.
4. Re-generate after structural changes so REALITY doesn't drift.

## Principles

- **Signal over completeness.** A 30-node map you understand beats 300 files you skimmed.
- **Follow the edges, not your assumptions.** The graph often shows a dependency you didn't expect —
  trust it over memory.
- **Cheap to refresh.** Regenerating the map should be one command, so it stays current.
