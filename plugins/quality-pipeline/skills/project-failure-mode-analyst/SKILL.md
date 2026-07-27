---
name: project-failure-mode-analyst
description: Identify, analyze, and prioritize project failure modes across the user's own decisions and execution, external AI behavior, and the human-AI handoff; then design prevention, detection, response, and learning controls. Use when the user asks for 项目失效模式, 常见失败模式, 人机协作风险, AI协作复盘, pre-mortem, FMEA, project risk diagnosis, or wants to understand how their own working patterns and AI collaboration could cause a project to fail.
---

# Project Failure Mode Analyst

Analyze how a project can fail across three coupled layers:

1. **Internal** — the user's decisions, attention, assumptions, skills, habits, and execution system;
2. **External AI** — model, tool, data, context, and service behavior outside the user's direct control;
3. **Interaction** — delegation, communication, verification, authority, handoffs, and feedback between the user and AI.

Treat every proposed failure mode as a hypothesis until supported by project evidence. Analyze the work system; do not diagnose the user's personality or mental health.

## Workflow

### 1. Define the project and failure boundary

Before requesting project artifacts, warn the user not to disclose secrets, credentials, personal data, regulated data, or confidential material they are not authorized to share. Ask for redacted excerpts, abstract descriptions, or synthetic examples when full details are unnecessary. Use the minimum sensitive context needed for the analysis.

Capture:

- intended outcome, user, and definition of done;
- current phase, deadline, dependencies, and irreversible decisions;
- quality, cost, safety, privacy, legal, and reputational constraints;
- AI systems, tools, data, permissions, and external actors involved;
- what counts as total failure, degraded success, delay, rework, or unacceptable harm.

Ask only for information whose absence would materially change the analysis. Otherwise state assumptions and proceed.

Do not help optimize a project whose objective is clearly unlawful or intended to cause serious harm. Limit assistance to risk reduction, prevention, compliance, or a safe alternative.

### 2. Map the work system

Decompose the project into stages such as:

`frame → research → decide → plan → produce → verify → release → monitor → learn`

For each stage, record:

- owner and decision authority;
- inputs and required context;
- action or transformation;
- expected output and acceptance test;
- handoff, dependency, and feedback loop.

Focus detailed analysis on critical, novel, irreversible, or weakly observable stages.

### 3. Gather evidence

Inspect available plans, prompts, outputs, decisions, revisions, test results, incidents, and feedback. Keep four evidence classes separate:

- **Observed** — directly present in project artifacts or events;
- **Reported** — stated by the user but not independently verified;
- **Inferred** — supported by a causal argument;
- **Generic** — a common pattern not yet evidenced in this project.

Never present a generic pattern as something the user “has.” Use it as a question or testable hypothesis.

Research current primary or authoritative sources when the analysis depends on a specific AI model, tool, regulation, security threat, service behavior, or recent incident. Cite direct sources and record their date or version.

### 4. Generate failure modes

At each stage, ask:

- What can be omitted, wrong, late, excessive, inconsistent, stale, insecure, or unverifiable?
- What can silently degrade while appearing successful?
- What single dependency or assumption can invalidate downstream work?
- How can a local failure propagate across the project?

Analyze all three layers. Read [failure-patterns.md](references/failure-patterns.md) when broader prompts are needed, but select only patterns relevant to the actual project.

Write each failure mode as an observable deviation:

`At <stage>, <actor/component> may <fail to meet requirement>, causing <local effect> and potentially <project effect>.`

Do not confuse:

- failure mode — how performance deviates;
- cause — why it happens;
- effect — what follows;
- control — what prevents, detects, contains, or recovers from it.

### 5. Build causal chains

For each plausible mode, identify:

- triggering conditions and root contributors;
- early warning signals;
- local, downstream, and worst credible effects;
- existing controls and how they could also fail;
- evidence for and against the hypothesis;
- interaction effects between the user and AI.

Look especially for coupled loops: unclear intent produces weak AI output, polished output increases user trust, insufficient verification preserves the error, and downstream reuse amplifies it.

### 6. Prioritize without false precision

Assess:

- **Impact** — consequence if the failure occurs;
- **Likelihood** — chance under current conditions;
- **Detectability** — chance of escaping detection before harm;
- **Exposure** — frequency or duration of contact with the failure;
- **Recoverability** — cost and reversibility after occurrence;
- **Evidence confidence** — strength of project-specific support.

Use Low/Medium/High or explicitly anchored numeric scales. Do not multiply scores into a risk-priority number unless the scales and decision rule are calibrated for the project. Override any ranking when a failure violates a hard safety, privacy, legal, or ethical constraint.

Assign:

- **Act now** — severe, imminent, hard to detect, or non-negotiable;
- **Test next** — important but uncertain; gather targeted evidence;
- **Monitor** — lower exposure or strong existing controls;
- **Park** — currently irrelevant or unsupported.

### 7. Design controls

Prefer controls in this order:

1. eliminate the risky step or unnecessary AI dependency;
2. constrain scope, permissions, inputs, and acceptable outputs;
3. add independent verification, tests, provenance, or a second path;
4. add checkpoints, monitoring, alerts, and explicit escalation;
5. prepare containment, rollback, recovery, and continuity;
6. document ownership, decision rights, and residual risk.

For AI-assisted work:

- keep consequential decisions under meaningful human authority;
- require stronger evidence as impact and irreversibility rise;
- verify claims against source material and outputs against acceptance tests;
- minimize sensitive data and review tool permissions;
- preserve prompts, assumptions, source links, versions, and decisions when traceability matters;
- define when AI must abstain, ask, escalate, or stop.

Avoid “be more careful” as a control. Make the control observable, owned, and testable.

### 8. Stress-test and operationalize

Run a pre-mortem on the proposed controls:

- How could each control be bypassed or become ceremonial?
- Which risk merely moves elsewhere?
- What new failure does the control introduce?
- What evidence would show that the ranking is wrong?

Produce the smallest actionable control plan. Assign an owner or role, timing, verification method, trigger, and fallback. Set a review event because the failure-mode register is a living project artifact.

## Output format

```markdown
## Executive diagnosis
<top failure pathways, confidence, and immediate action>

## Scope and evidence
<project boundary, assumptions, observed/reported/inferred/generic evidence>

## Failure-mode register
| Layer | Stage | Failure mode | Cause/trigger | Effect | Existing control | Impact / Likelihood / Escape detection / Recoverability | Confidence | Priority |

## Coupled human–AI failure loops
<causal chains that cross layers>

## Control plan
| Priority | Control | Type | Owner | Trigger/timing | Verification | Fallback |

## Unknowns to test
<cheap tests that could confirm or falsify important hypotheses>

## Monitoring and review
<leading indicators, review event, escalation and stop conditions>
```

Adapt the format to project size. For a small project, return the top five modes and controls rather than a large register.

## Quality checks

Before finalizing, verify:

- Internal, external AI, and interaction layers were all considered.
- Modes are observable deviations, not vague labels or personality judgments.
- Causes, effects, controls, and evidence are not conflated.
- Generic patterns are labeled as hypotheses.
- Silent failures and control failures were considered.
- Ranking reflects uncertainty, detectability, and recoverability.
- Every urgent mode has a concrete owner, test, trigger, and fallback.
- The analysis can be updated as the project changes.
