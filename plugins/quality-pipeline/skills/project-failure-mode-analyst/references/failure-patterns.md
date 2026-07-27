# Failure-pattern prompts

Use this catalogue to widen an analysis, not to assert that a pattern exists. Select patterns that match the project stage and seek evidence.

## Internal: user decisions and execution

- **Goal ambiguity** — success, users, or constraints remain undefined.
- **Premature commitment** — a solution is selected before alternatives or evidence are examined.
- **Confirmation loop** — evidence is sought or interpreted mainly to preserve an existing belief.
- **Scope drift** — additions accumulate without revisiting time, quality, or resource tradeoffs.
- **Priority churn** — work repeatedly restarts before feedback can accumulate.
- **Planning mismatch** — estimates omit uncertainty, dependencies, review, or rework.
- **Attention fragmentation** — critical context is lost across interruptions or parallel work.
- **Decision amnesia** — rationale, assumptions, or rejected options are not recorded.
- **Weak acceptance test** — “looks good” substitutes for an observable definition of done.
- **Verification avoidance** — uncomfortable or expensive checks are deferred until late.
- **Escalation delay** — a blocked or unsafe condition is tolerated without a trigger for help.
- **No stopping rule** — polishing, research, or iteration continues without marginal-value checks.
- **Learning failure** — incidents are fixed locally without updating the workflow.

## External: AI, tools, data, and services

- **Confabulation** — plausible claims, citations, or details are unsupported.
- **Context loss** — important constraints are omitted, truncated, stale, or misunderstood.
- **Instruction conflict** — competing prompts or policies produce unintended behavior.
- **Capability mismatch** — the assigned task exceeds the model, tool, or modality's reliable range.
- **Non-determinism** — repeated runs vary in ways the workflow does not tolerate.
- **Tool execution error** — the model plans correctly but a tool call fails or targets the wrong state.
- **Data contamination** — sources are outdated, biased, incomplete, malicious, or irrelevant.
- **Hidden dependency** — a service, model version, connector, permission, or rate limit changes.
- **Privacy leakage** — sensitive information is exposed in prompts, logs, tools, or outputs.
- **Security failure** — prompt injection, excessive permissions, or unsafe generated code creates harm.
- **Provenance loss** — claims and artifacts cannot be traced to sources, prompts, or versions.
- **Evaluation gap** — success is judged by fluency or appearance instead of task-grounded tests.
- **Silent partial completion** — some requirements are skipped without a visible failure.
- **Recovery gap** — no rollback, fallback model, manual path, or incident procedure exists.

## Interaction: human–AI collaboration

- **Poor delegation boundary** — AI receives either an underspecified goal or authority it should not hold.
- **Role ambiguity** — responsibility for deciding, checking, and signing off is unclear.
- **Assumption mismatch** — user and AI operate with different definitions, constraints, or time horizons.
- **Automation bias** — polished output receives less scrutiny than its impact warrants.
- **Reflexive rejection** — useful AI evidence is dismissed without testing because trust is too low.
- **Feedback starvation** — AI receives no examples, test results, or correction signal.
- **Evaluation circularity** — the same model generates and “independently” approves its own work.
- **Handoff loss** — context, unresolved issues, or rationale disappears between sessions or agents.
- **Error amplification** — an early AI error is copied into plans, code, summaries, and later decisions.
- **Responsibility laundering** — “the AI suggested it” substitutes for accountable human judgment.
- **Over-iteration** — repeated prompting changes style but does not resolve the underlying evidence gap.
- **Skill atrophy** — verification or domain understanding weakens because it is never exercised.
- **Incentive mismatch** — speed, agreement, or polished delivery is rewarded over correctness.
- **No challenge channel** — neither party is required or empowered to surface uncertainty and dissent.

## Cross-stage prompts

For each selected pattern, ask:

1. What artifact or event would prove this is occurring?
2. What evidence would disconfirm it?
3. At which stage would it first become detectable?
4. What is the latest safe detection point?
5. How could it propagate across internal, AI, and interaction layers?
6. Which control removes the cause, and which merely catches the effect?
7. How could the control itself fail?
