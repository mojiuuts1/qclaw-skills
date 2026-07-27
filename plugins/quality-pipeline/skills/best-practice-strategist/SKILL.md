---
name: best-practice-strategist
description: Research best-practice principles, turn them into explicit evaluation criteria, compare candidate approaches, and recommend the best-fit strategy with evidence, tradeoffs, assumptions, and validation steps. Use when the user asks for best practices, selection criteria, a decision framework, strategy comparison,方案选型, 路线选择, or “最佳策略”; especially when “best” depends on goals, constraints, risks, or current external evidence.
---

# Best Practice Strategist

Find defensible best practices and convert them into a context-specific decision. Treat “best” as best fit for the stated objective and constraints, not as a universal claim.

## Workflow

### 1. Frame the decision

Extract:

- objective and definition of success;
- decision scope and time horizon;
- constraints, non-negotiables, and risk tolerance;
- stakeholders and who bears each tradeoff;
- known candidates and the status quo.

Ask only for missing information that could materially reverse the recommendation. Otherwise state reasonable assumptions and proceed.

### 2. Research relevant best practices

Use current research when practices, products, regulations, standards, or market conditions may have changed. Prefer primary and authoritative sources, then strong systematic syntheses and credible field evidence. Separate:

- **principles**: durable guidance and causal logic;
- **patterns**: repeatable implementations that work under stated conditions;
- **requirements**: mandatory rules, safety constraints, or compatibility gates;
- **conventions**: common practice without strong evidence of superiority.

For every proposed principle, record the evidence, applicable conditions, exceptions, and likely failure modes. Do not treat popularity, authority, or a single success story as proof.

### 3. Build the evaluation model

Translate the objective and principles into criteria that are:

- relevant to the decision;
- mutually distinguishable enough to avoid double counting;
- measurable or anchored with observable descriptions;
- complete enough to capture major benefits, costs, risks, and reversibility.

Split criteria into:

1. **Gates** — pass/fail requirements. Eliminate any candidate that fails one.
2. **Weighted criteria** — dimensions used to rank candidates that pass.

Define each criterion before scoring. State its weight, measurement method, scoring anchors, and rationale. Normalize weights to 100%. Derive weights from the value of moving from the worst plausible performance to the best plausible performance on each criterion (swing weighting), not from criterion names or abstract importance alone. Involve the affected decision makers when preferences determine the weights.

Use a linear weighted sum only when score intervals are meaningfully comparable and strong performance on one criterion may compensate for weak performance on another. Otherwise keep non-compensable requirements as gates or use a qualitative/alternative decision model. Use a consistent scoring scale, normally 1–5:

- 1 = materially fails the criterion;
- 3 = acceptable with meaningful tradeoffs;
- 5 = strongly satisfies the criterion.

Use ranges or confidence labels when evidence is uncertain. Avoid false precision.

### 4. Generate viable strategies

Include at least:

- the status quo or “do nothing” baseline when meaningful;
- two genuinely distinct candidates;
- a staged, hybrid, or reversible option when it could reduce uncertainty.

Describe each candidate in enough operational detail to score it fairly. Do not create weak straw-man alternatives.

### 5. Evaluate and stress-test

Apply gates first. Score only surviving candidates. For each score, give a short evidence-based rationale.

When the additive model is appropriate, calculate the weighted total:

`total = Σ(weight × normalized score)`

Then test robustness:

- vary the most consequential weights and uncertain scores;
- identify assumptions that would change the winner;
- compare downside, reversibility, option value, and cost of delay;
- check whether correlated criteria were counted twice;
- check whether compensation between criteria is actually acceptable;
- run a pre-mortem on the leading strategy.

If small reasonable changes alter the winner, report a conditional recommendation instead of claiming a single optimum.

### 6. Recommend and operationalize

Lead with the recommended strategy and why it wins for this context. Include:

- decisive criteria and material tradeoffs;
- rejected alternatives and why they lost;
- assumptions, confidence, and unresolved evidence gaps;
- immediate actions, owner or role, sequence, and decision checkpoints;
- leading indicators, outcome metrics, guardrails, and stop/pivot conditions;
- the cheapest test that could falsify the recommendation.

Prefer a reversible experiment before a large commitment when uncertainty is high and learning is affordable.

## Output format

Use the smallest format that preserves the reasoning:

```markdown
## Recommendation
<best-fit strategy, confidence, and one-sentence rationale>

## Decision context
<objective, constraints, assumptions, and scope>

## Best-practice principles
| Principle | Evidence or rationale | Applies when | Exception/failure mode |

## Evaluation criteria
| Criterion | Gate/weight | Measurement and anchors | Why it matters |

## Strategy comparison
| Strategy | Gate result | Criterion scores | Weighted total | Key tradeoff |

## Robustness
<sensitivity, pivotal assumptions, downside, reversibility>

## Action plan
<first steps, metrics, checkpoints, stop/pivot rules>

## Sources
<direct links when external research was used>
```

Omit empty sections. Keep facts, assumptions, estimates, and value judgments visibly distinct.

## Quality checks

Before finalizing, verify:

- “Best” is tied to an explicit objective and context.
- Every mandatory constraint is represented as a gate.
- Criteria are defined before candidates are scored.
- Scores have evidence or transparent rationale.
- No candidate is favored through asymmetric detail or double counting.
- Uncertainty and sensitivity could be audited by another reader.
- The recommendation includes execution, measurement, and a way to be proven wrong.
