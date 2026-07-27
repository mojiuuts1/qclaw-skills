---
name: tool-stack-recommender
description: Research, evaluate, rank, and arrange the best-fit tool or coherent tool stack for a project or task workflow, including existing tools, integrations, sequencing, costs, risks, alternatives, and adoption steps. Use when the user asks for 工具建议, 工具推荐, 最佳工具, 工具选型, 软件选型, AI工具组合, 工具排列, 技术栈推荐, tool stack, app stack, vendor comparison, or wants to improve an end-to-end workflow with appropriate tools.
---

# Tool Stack Recommender

Recommend the smallest coherent tool stack that best fits the user's project. Optimize the end-to-end workflow, not the popularity or isolated feature count of individual products.

Treat “best” as context-dependent and time-sensitive. Separate verified facts, vendor claims, estimates, assumptions, and value judgments.

## Workflow

Use a light path for a single, low-stakes task: frame the job, verify current candidates, apply essential gates, compare a small shortlist, and recommend one primary tool plus an alternative. Use the full workflow for multi-stage projects, integrated stacks, consequential decisions, or costly migrations.

### 1. Frame the project

Capture:

- outcome, users, definition of done, and time horizon;
- project stages, recurring tasks, volume, and collaboration model;
- current tools, data locations, skills, operating systems, and constraints;
- budget range and whether it is monthly, annual, per-seat, usage-based, or total;
- security, privacy, compliance, accessibility, residency, licensing, and procurement requirements;
- required integrations, formats, APIs, automation, offline use, and portability;
- tolerance for setup effort, maintenance, vendor dependence, and migration.

Ask only for missing information that could materially reverse the recommendation. Otherwise state assumptions and offer conditional branches.

Before requesting artifacts, warn against sharing credentials, secrets, personal data, or unauthorized confidential information. Use redacted or abstract descriptions where possible.

### 2. Map jobs to capabilities

Decompose the workflow:

`capture → research → decide → plan → create → collaborate → verify → deliver → monitor → archive`

For each relevant stage, define:

- job to be done and responsible role;
- input, output, and acceptance test;
- required capability, not a product name;
- frequency, criticality, and automation opportunity;
- upstream and downstream handoffs.

Do not invent tool categories for stages that do not need them.

### 3. Audit the current stack

Identify:

- capabilities already covered well;
- gaps, bottlenecks, duplicated functions, and manual handoffs;
- systems of record and sources of truth;
- switching costs, sunk costs, and constraints imposed by existing tools;
- tools available in the current environment versus tools that would require purchase, installation, connection, or approval.

Include “keep the current tool” and “use no additional tool” as candidates when appropriate. Do not recommend replacement merely because a newer product exists.

### 4. Research current candidates

Because tool capabilities, prices, limits, ownership, and availability change, verify current recommendations with up-to-date research.

If live access to current official sources is unavailable, say that current details could not be verified. Do not present remembered prices, limits, security posture, or availability as current facts. Mark affected claims as unverified, avoid precise comparisons that depend on them, and give the user direct official checks to complete before acting.

Prefer:

1. official product documentation, pricing, security, privacy, status, API, and release pages;
2. applicable standards, regulator guidance, and primary benchmarks;
3. credible independent testing with disclosed methodology;
4. recent user evidence only for experience claims that primary sources cannot establish.

Record the research date, plan or version, region, currency, and source link. Treat vendor marketing as a claim, not proof of comparative superiority. Never invent a feature, price, integration, certification, or availability.

Shortlist only candidates that are realistically obtainable and support the required workflow.

### 5. Apply gates before ranking

Eliminate or conditionally reject tools that fail non-negotiable requirements such as:

- platform, region, language, or accessibility;
- data handling, privacy, security, residency, or compliance;
- required export format, API, integration, or identity system;
- budget ceiling, licensing rights, procurement, or service continuity;
- minimum reliability, support, offline access, or performance.

Do not let high scores on optional features compensate for a failed gate.

### 6. Evaluate fit and total stack value

Read [evaluation-rubric.md](references/evaluation-rubric.md) when building a detailed comparison. Select only criteria that matter to this decision and define their measurement anchors before scoring.

Derive weights from the value of moving from the worst acceptable result to the best plausible result on each criterion. Use qualitative ratings or ranges when evidence is weak. Avoid false precision.

Evaluate both:

- **tool fit** — how well each candidate performs its assigned job;
- **stack fit** — how well the full set works together with minimal friction, duplication, and correlated failure.

Account for total cost of ownership: subscription or usage, implementation, integration, training, administration, maintenance, migration, data transfer, switching, and failure costs.

### 7. Arrange the tool stack

For every recommended tool, specify:

- workflow position and exact job;
- why it is primary rather than an alternative;
- input, output, data owner, and handoff;
- system-of-record status;
- automation or integration path;
- human approval or verification point;
- fallback, export, and replacement path.

Use three labels:

- **Core now** — necessary to run the workflow;
- **Add after validation** — useful only after a stated trigger or pilot result;
- **Optional** — situational benefit, not required.

Prefer one capable tool over several overlapping tools unless separation provides meaningful quality, independence, security, or resilience.

### 8. Analyze failure modes

Stress-test the proposed stack across:

- user execution and adoption;
- individual tools, AI models, vendors, data, and services;
- integrations and human–tool handoffs.

Check for tool sprawl, weak ownership, silent partial failure, incompatible formats, broken automation, excessive permissions, sensitive-data leakage, unverifiable AI output, API or pricing changes, outages, vendor lock-in, loss of exportability, duplicated sources of truth, and unavailable recovery paths.

Convert urgent modes into prevention, detection, response, stop, rollback, and fallback controls. Label generic risks as hypotheses until supported by project evidence.

### 9. Validate before committing

Design a proof-of-work using representative project tasks, real constraints, and predefined acceptance tests. Compare the incumbent and finalists on the same inputs.

Measure relevant outcomes such as:

- completion quality and error rate;
- elapsed and human-review time;
- handoff failures and rework;
- cost under realistic volume;
- learnability and adoption;
- export, recovery, and integration behavior.

Use a reversible pilot when uncertainty, migration cost, or commitment is high. Define the evidence that would reject the leading recommendation.

### 10. Recommend and sequence adoption

Lead with the proposed stack and confidence. Provide:

- ordered workflow and system architecture;
- core, later, and optional tools;
- runner-up and low-cost/open/portable alternatives where useful;
- rejected tools and decisive reasons;
- implementation order, owner, migration, pilot, and review date;
- key risks, fallback paths, and stop or switch conditions;
- estimated costs with assumptions and source dates.

Do not buy, install, connect, subscribe, migrate data, or change production systems unless the user explicitly asks.

## Output format

```markdown
## Recommended tool stack
<one-paragraph recommendation, confidence, date, region, and assumptions>

## Workflow arrangement
| Order | Stage/job | Primary tool | Input → output | Owner/approval | Fallback |

## Why these tools
| Tool | Status | Decisive fit | Material limitation | Cost basis and sensitivity | Evidence |

## Alternatives
| Job | Runner-up | Choose it when | Why it lost here |

## Stack risks and controls
| Failure mode | Priority | Prevention/detection | Response/fallback |

## Adoption plan
<pilot, sequence, migration, metrics, checkpoints, stop/switch conditions>

## Sources
<official and direct links with verification date>
```

For every cost estimate, state the pricing model, plan, assumed users or usage, region, currency, verification date, inclusions, and likely sensitivity to changed assumptions. Label promotional or non-public/negotiated pricing. Prefer a range or scenario comparison over an unjustified single number.

Use a shorter answer for a simple task. Do not overwhelm the user with an exhaustive market catalogue.

## Quality checks

Before finalizing, verify:

- Recommendations map to explicit project jobs and acceptance tests.
- Current tools and “no new tool” were fairly considered.
- Every hard constraint was applied as a gate.
- Product facts, pricing, limits, and availability are current and sourced.
- Tool fit and whole-stack fit were both evaluated.
- Costs include integration, learning, operation, migration, and failure.
- The stack has clear systems of record, handoffs, owners, and fallbacks.
- Redundant tools have a justified purpose.
- Important failure modes and reversibility were addressed.
- The recommendation includes a real pilot and a way to be proven wrong.
