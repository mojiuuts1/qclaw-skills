# Tool evaluation rubric

Select only decision-relevant criteria. Define project-specific anchors before rating; do not reuse default weights across projects.

## Capability and outcome

- **Job coverage** — satisfies the required job without major workaround.
- **Output quality** — meets task-grounded acceptance tests.
- **Reliability** — behaves consistently at required volume and criticality.
- **Performance** — latency, throughput, capacity, and resource use.
- **Automation** — APIs, webhooks, scheduling, batch support, and event handling.
- **Observability** — logs, audit trail, status, errors, usage, and monitoring.

## Workflow and people

- **Usability** — effort required for the actual users and accessibility needs.
- **Learnability** — time to competent, safe, repeatable use.
- **Collaboration** — roles, permissions, review, comments, and versioning.
- **Handoff quality** — preserves context and structure between workflow stages.
- **Administration** — provisioning, identity, policy, support, and maintenance burden.
- **Adoption fit** — matches team skills, habits, capacity, and change tolerance.

## Data, integration, and portability

- **Compatibility** — works with required platforms, formats, and current tools.
- **Integration quality** — official support, API stability, depth, and error handling.
- **Data ownership** — ownership, retention, deletion, training use, and contractual rights.
- **Exportability** — complete, usable export in documented formats.
- **Portability** — ability to replace the tool without rebuilding the entire workflow.
- **Source of truth** — supports an unambiguous authoritative record.
- **Offline/continuity** — tolerates network, vendor, or service interruption where required.

## Security, privacy, and governance

- **Access control** — least privilege, roles, authentication, and identity integration.
- **Security posture** — relevant documented controls, patching, vulnerability handling, and incident response.
- **Privacy fit** — data minimization, purpose, residency, retention, and subject rights.
- **Compliance evidence** — applicable certifications or attestations, verified in scope.
- **Auditability** — provenance, decision records, model/tool versions, and administrative logs.
- **AI controls** — source grounding, evaluation, human oversight, abstention, and content/data controls.

## Economics and vendor risk

- **Direct cost** — licenses, seats, usage, storage, transfer, add-ons, and support.
- **Implementation cost** — configuration, integration, customization, and migration.
- **Operating cost** — administration, review, monitoring, maintenance, and training.
- **Failure cost** — downtime, errors, rework, security events, and recovery.
- **Switching cost** — contract exit, data extraction, retraining, and replacement work.
- **Pricing predictability** — exposure to variable usage, tiers, minimums, and price changes.
- **Vendor/project health** — support model, maintenance, release activity, ownership, and continuity.
- **Supply-chain risk** — dependencies, provenance, third-party components, and concentration.

## Sustainability and strategic fit

- **Scalability** — supports plausible growth without disproportionate cost or redesign.
- **Adaptability** — can evolve with requirements and integrate future components.
- **Open standards** — uses documented, interoperable formats and interfaces.
- **Energy/resource impact** — material environmental or infrastructure implications.
- **Strategic alignment** — reinforces the user's architecture and operating model.

## Rating discipline

For each selected criterion:

1. define a failure gate if performance is non-negotiable;
2. define observable worst acceptable, middle, and best plausible anchors;
3. cite the evidence used for each rating;
4. state confidence and missing evidence;
5. test whether reasonable weight or rating changes alter the winner.

If criteria cannot be meaningfully combined, present the tradeoff or conditional recommendation instead of forcing a single numeric winner.
