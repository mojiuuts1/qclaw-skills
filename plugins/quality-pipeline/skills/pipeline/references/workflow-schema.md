# Pipeline workflow schema v2

Use schema version 2 for executable workflows.

## Top-level fields

- `schema_version`: must be `2`.
- `name`, `description`, `version`: workflow identity.
- `inputs`: named input mappings.
- `limits`: default runtime bounds.
- `steps`: ordered step list.
- `outputs`: explicit workflow return contract.
- `gates`: optional regular-expression checks that can mark the run blocked.

## Inputs

```yaml
inputs:
  question:
    default: ""
    required: true
    aliases: [问题]
  include_tools:
    type: boolean
    default: true
    aliases: [包含工具]
```

Arguments use `key=value`. Aliases map to the canonical key. Boolean values accept `true/false`, `yes/no`, `1/0`, `是/否`, and `开启/关闭`.

## Steps

```yaml
- id: draft
  skill: recursive-ai
  when: include_tools == true
  prompt: |
    Work on: {{ question }}
  capture: draft_output
  timeout_seconds: 180
  max_output_chars: 12000
  on_failure: halt
  fallback:
    from: previous_output
```

- `capture` stores the entire textual skill response. Skills do not need to return JSON fields.
- `when` supports one comparison: `name == value` or `name != value`.
- `on_failure` is `halt` by default. Use `continue` only with a meaningful fallback.
- `fallback.from` copies a prior variable; `fallback.value` supplies literal text.
- `external: true` requires `requires_consent: <boolean-input>`. The runner also blocks the step when `contains_sensitive_data=true`.

## Limits

```yaml
limits:
  max_prompt_chars: 50000
  max_step_output_chars: 16000
  default_timeout_seconds: 180
```

The runner fails visibly instead of silently truncating oversized content.

## Outputs

```yaml
outputs:
  primary: final_answer
  evidence: final_fact_check_report
```

Every output must reference an input or prior `capture`. The runner returns all declared outputs and a step trace.

## Completion gates

```yaml
gates:
  - variable: final_report
    pattern: "FINAL_STATUS: PASS"
    message: "Final verification did not pass."
```

Failed gates return `status: blocked` while preserving outputs and the trace. Use gates only with a stable machine-readable marker explicitly required by the producing step.

## Adapter protocol

Run:

```text
ruby scripts/pipeline_runner.rb run workflow.yaml --adapter /absolute/path key=value
```

The runner sends one JSON object to the adapter on stdin:

```json
{"step_id":"draft","skill":"recursive-ai","prompt":"...","timeout_seconds":180}
```

The adapter must return:

```json
{"result":"complete textual skill response"}
```

This separates deterministic orchestration from the model or skill host. An adapter may invoke a local agent, remote model, or test double. Never pass secrets to an adapter that is not authorized to receive them.
