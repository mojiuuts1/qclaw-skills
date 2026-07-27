---
name: pipeline
description: Execute and validate composable YAML workflows that call multiple skills in order with explicit inputs, whole-text captures, conditions, context limits, timeouts, consent gates, fallbacks, traces, and declared outputs. Use when the user invokes /pipeline, asks to run the quality or framework workflow, compose several skills, validate a workflow, or diagnose pipeline execution.
---

# Pipeline

Execute workflows from the `workflows/` directory beside this `SKILL.md`. Resolve runner, workflow, reference, and test paths relative to this Skill directory so the workflow works both as a standalone Skill and inside an installed Plugin. Use schema version 2 and the deterministic runner for validation and automated adapter-based execution.

## Invocation

```text
/pipeline quality question=如何搭建个人知识体系
/pipeline quality 问题=如何搭建个人知识体系 包含工具=false
/pipeline framework domain=投资 goal=设计风险评估框架
```

Arguments use `key=value`; quoted values may contain spaces. Input aliases are declared in the workflow.

## Mandatory preflight

Before executing:

1. Read the selected workflow.
2. Run:

   ```text
   ruby <pipeline-skill-dir>/scripts/pipeline_runner.rb validate <workflow>
   ruby <pipeline-skill-dir>/scripts/pipeline_runner.rb plan <workflow> <arguments>
   ```

3. Stop on unknown inputs, missing required values, skills, variables, captures, outputs, invalid conditions, or invalid consent declarations.
4. Warn the user not to provide secrets or unauthorized sensitive data.
5. Set `contains_sensitive_data=true` whenever supplied material contains or plausibly contains sensitive data.
6. Do not run an `external: true` step unless its consent input is explicitly true and `contains_sensitive_data` is false.

## Execution contract

Execute enabled steps in order:

1. Render `{{ variable }}` from canonical inputs and prior captures.
2. Invoke the named skill with the rendered prompt.
3. Store the entire textual response under `capture`. Do not look for an `output` or `report` field.
4. Enforce `timeout_seconds`, `max_output_chars`, and global prompt limits.
5. On failure, halt unless `on_failure: continue`; continuing requires a meaningful fallback.
6. Record each step as completed, skipped, skipped_external, degraded, or failed.
7. Return every variable declared under top-level `outputs`, plus the trace.

Never silently truncate an oversized prompt or response. Stop and report which limit was exceeded.

## Automated execution

Use the runner with an executable adapter:

```text
ruby <pipeline-skill-dir>/scripts/pipeline_runner.rb run \
  <pipeline-skill-dir>/workflows/quality.yaml \
  --adapter /absolute/path/to/adapter \
  question=...
```

Read [workflow-schema.md](references/workflow-schema.md) when creating or changing a workflow. The adapter protocol separates orchestration from the model host.

## Agent-hosted execution

When no adapter is available, follow the same contract directly:

- validate and plan with the runner first;
- invoke each skill yourself;
- treat its complete response as the capture;
- obey conditions, consent, limits, fallbacks, and declared outputs;
- present the primary output and all evidence outputs;
- never claim success when an evidence output still contains confirmed errors.

## Quality workflow

`quality` v1.4 is intended for substantive projects, decisions, plans, or tasks. It provides:

```text
best-practice-strategist
→ project-failure-mode-analyst (optional)
→ tool-stack-recommender (optional)
→ recursive-ai
→ grill (optional, external consent required)
→ fact-check
→ recursive-ai factual correction
→ final fact-check
```

For simple writing, translation, calculation, or conversation, skip this workflow or explicitly disable irrelevant steps.

## Framework workflow

`framework` v1.1 provides:

```text
framework-builder → recursive-ai → fact-check
```
