# QClaw Skills

QClaw Skills packages reusable quality workflows for Codex. The first release is
`quality-pipeline`, a composable workflow that turns a complex question into a
risk-aware, tool-aware, iteratively revised, and fact-checked deliverable.

## What the Quality Pipeline does

```text
best-practice-strategist
→ project-failure-mode-analyst (optional)
→ tool-stack-recommender (optional)
→ recursive-ai
→ grill (optional, explicit consent required)
→ fact-check
→ recursive-ai factual correction
→ final fact-check
```

The workflow fails visibly, records a trace, preserves complete step outputs,
supports meaningful fallbacks, and does not declare a result verified unless the
final fact-check gate passes.

## Install

Clone this repository:

```bash
git clone https://github.com/mojiuuts1/qclaw-skills.git
cd qclaw-skills
```

Register the repository as a local Codex marketplace:

```bash
codex plugin marketplace add "$(pwd)"
```

Install the plugin:

```bash
codex plugin add quality-pipeline@qclaw-skills
```

Start a new Codex thread after installation so the new skills and command are
discovered.

## Use

Run the default quality workflow:

```text
/pipeline quality 问题="如何建立一个长期可维护的个人知识管理系统"
```

Disable optional stages:

```text
/pipeline quality 问题="改进这份内部说明" 包含工具=false 包含失效模式=false
```

Allow external adversarial review only for non-sensitive material:

```text
/pipeline quality 问题="制定产品验证方案" 允许外部审查=true 包含敏感数据=false
```

Never send passwords, API keys, private personal information, or unauthorized
confidential material to an external review step.

## Trigger individual skills

The bundled skills can also be triggered independently with phrases such as:

- `最佳实践` or `最佳策略`
- `失效模式` or `人机协作风险`
- `工具建议` or `工具选型`
- `事实核查`
- `/grill`

## Validate locally

```bash
python3 /path/to/plugin-creator/scripts/validate_plugin.py \
  plugins/quality-pipeline

ruby plugins/quality-pipeline/skills/pipeline/scripts/pipeline_runner.rb \
  validate plugins/quality-pipeline/skills/pipeline/workflows/quality.yaml
```

## Repository layout

```text
.agents/plugins/marketplace.json
plugins/quality-pipeline/
  .codex-plugin/plugin.json
  commands/pipeline.md
  skills/
  scripts/
backups/
```

## License

MIT
