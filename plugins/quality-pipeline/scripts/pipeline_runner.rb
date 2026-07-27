#!/usr/bin/env ruby

require "json"
require "tempfile"
require "timeout"
require "yaml"

class PipelineError < StandardError; end

module PipelineRunner
  module_function

  def load_workflow(path)
    data = YAML.safe_load(File.read(path), [], [], true)
    raise PipelineError, "workflow must be a mapping" unless data.is_a?(Hash)
    data
  rescue Psych::SyntaxError => e
    raise PipelineError, "invalid YAML: #{e.message}"
  end

  def inputs_spec(workflow)
    workflow.fetch("inputs", {})
  end

  def parse_boolean(value)
    return value if value == true || value == false
    case value.to_s.downcase
    when "true", "1", "yes", "on", "是", "开启" then true
    when "false", "0", "no", "off", "否", "关闭" then false
    else
      raise PipelineError, "invalid boolean: #{value}"
    end
  end

  def resolve_inputs(workflow, raw_args)
    specs = inputs_spec(workflow)
    alias_map = {}
    specs.each do |name, spec|
      ([name] + Array(spec["aliases"])).each do |key|
        raise PipelineError, "duplicate input alias: #{key}" if alias_map.key?(key)
        alias_map[key] = name
      end
    end

    supplied = {}
    raw_args.each do |arg|
      key, value = arg.split("=", 2)
      raise PipelineError, "arguments must use key=value: #{arg}" unless value
      canonical = alias_map[key]
      raise PipelineError, "unknown input: #{key}" unless canonical
      supplied[canonical] = value
    end

    specs.each_with_object({}) do |(name, spec), result|
      value = supplied.key?(name) ? supplied[name] : spec["default"]
      raise PipelineError, "missing required input: #{name}" if spec["required"] && value.to_s.empty?
      value = parse_boolean(value) if spec["type"] == "boolean"
      allowed = spec["allowed"]
      if allowed && !allowed.include?(value)
        raise PipelineError, "#{name} must be one of: #{allowed.join(', ')}"
      end
      result[name] = value
    end
  end

  def condition_met?(expression, context)
    return true if expression.nil? || expression.to_s.strip.empty?
    match = expression.to_s.match(/\A\s*([a-zA-Z_][\w-]*)\s*(==|!=)\s*(true|false|[a-zA-Z0-9_.-]+)\s*\z/)
    raise PipelineError, "unsupported condition: #{expression}" unless match
    key, operator, raw_expected = match.captures
    raise PipelineError, "condition references unknown variable: #{key}" unless context.key?(key)
    expected = case raw_expected
               when "true" then true
               when "false" then false
               else raw_expected
               end
    operator == "==" ? context[key] == expected : context[key] != expected
  end

  def variables_in(text)
    text.to_s.scan(/\{\{\s*([a-zA-Z_][\w-]*)\s*\}\}/).flatten.uniq
  end

  def render(text, context)
    text.to_s.gsub(/\{\{\s*([a-zA-Z_][\w-]*)\s*\}\}/) do
      key = Regexp.last_match(1)
      raise PipelineError, "unresolved variable: #{key}" unless context.key?(key)
      context[key].to_s
    end
  end

  def fallback_value(step, context)
    fallback = step["fallback"]
    return nil unless fallback
    return context[fallback["from"]] if fallback["from"] && context.key?(fallback["from"])
    fallback["value"]
  end

  def validate!(workflow, workflow_path)
    %w[schema_version name version description inputs steps outputs].each do |key|
      raise PipelineError, "missing top-level key: #{key}" unless workflow.key?(key)
    end
    raise PipelineError, "schema_version must be 2" unless workflow["schema_version"] == 2
    raise PipelineError, "steps must be a non-empty array" unless workflow["steps"].is_a?(Array) && !workflow["steps"].empty?
    raise PipelineError, "outputs must contain primary" unless workflow["outputs"].is_a?(Hash) && workflow["outputs"]["primary"]

    specs = inputs_spec(workflow)
    known = specs.keys.dup
    aliases = []
    specs.each do |name, spec|
      raise PipelineError, "input #{name} must be a mapping" unless spec.is_a?(Hash)
      ([name] + Array(spec["aliases"])).each do |entry|
        raise PipelineError, "duplicate input alias: #{entry}" if aliases.include?(entry)
        aliases << entry
      end
    end

    ids = []
    skills_root = File.expand_path("../..", __dir__)
    workflow["steps"].each do |step|
      %w[id skill prompt capture].each do |key|
        raise PipelineError, "step missing #{key}: #{step.inspect}" if step[key].to_s.empty?
      end
      raise PipelineError, "duplicate step id: #{step['id']}" if ids.include?(step["id"])
      raise PipelineError, "duplicate capture: #{step['capture']}" if known.include?(step["capture"])
      ids << step["id"]
      unless [nil, "halt", "continue"].include?(step["on_failure"])
        raise PipelineError, "step #{step['id']} has invalid on_failure"
      end
      if step["on_failure"] == "continue" && !step["fallback"]
        raise PipelineError, "step #{step['id']} continues without fallback"
      end
      skill_file = File.join(skills_root, step["skill"], "SKILL.md")
      raise PipelineError, "missing skill: #{step['skill']} (#{skill_file})" unless File.file?(skill_file)
      variables_in(step["prompt"]).each do |variable|
        raise PipelineError, "step #{step['id']} references unavailable variable: #{variable}" unless known.include?(variable)
      end
      condition = step["when"]
      condition_key = condition.to_s[/\A\s*([a-zA-Z_][\w-]*)/, 1]
      if condition_key && !known.include?(condition_key)
        raise PipelineError, "step #{step['id']} condition references unavailable variable: #{condition_key}"
      end
      if step["external"] && step["requires_consent"].to_s.empty?
        raise PipelineError, "external step #{step['id']} must declare requires_consent"
      end
      if step["external"]
        consent = specs[step["requires_consent"]]
        unless consent && consent["type"] == "boolean"
          raise PipelineError, "external step #{step['id']} consent must reference a boolean input"
        end
      end
      fallback_from = step.dig("fallback", "from")
      if fallback_from && !known.include?(fallback_from)
        raise PipelineError, "step #{step['id']} fallback references unavailable variable: #{fallback_from}"
      end
      known << step["capture"]
    end

    workflow["outputs"].each do |label, variable|
      raise PipelineError, "output #{label} references unavailable variable: #{variable}" unless known.include?(variable)
    end
    Array(workflow["gates"]).each do |gate|
      raise PipelineError, "gate must declare variable and pattern" if gate["variable"].to_s.empty? || gate["pattern"].to_s.empty?
      raise PipelineError, "gate references unavailable variable: #{gate['variable']}" unless known.include?(gate["variable"])
      Regexp.new(gate["pattern"])
    rescue RegexpError => e
      raise PipelineError, "invalid gate pattern: #{e.message}"
    end
    true
  end

  def invoke_adapter(adapter, payload, timeout_seconds)
    stdout = stderr = nil
    status = nil
    pid = nil
    Tempfile.create("pipeline-input") do |input|
      Tempfile.create("pipeline-output") do |output|
        Tempfile.create("pipeline-error") do |error|
          input.write(JSON.generate(payload))
          input.flush
          pid = Process.spawn(adapter, in: input.path, out: output.path, err: error.path)
          begin
            Timeout.timeout(timeout_seconds) do
              _, status = Process.wait2(pid)
            end
          rescue Timeout::Error
            Process.kill("TERM", pid) rescue nil
            begin
              Timeout.timeout(1) { Process.wait(pid) }
            rescue Timeout::Error
              Process.kill("KILL", pid) rescue nil
              Process.wait(pid) rescue nil
            end
            raise PipelineError, "step timed out after #{timeout_seconds}s"
          end
          output.rewind
          error.rewind
          stdout = output.read
          stderr = error.read
        end
      end
    end
    raise PipelineError, "adapter failed: #{stderr.strip}" unless status.success?
    response = JSON.parse(stdout)
    raise PipelineError, "adapter response must contain string result" unless response["result"].is_a?(String)
    response["result"]
  rescue JSON::ParserError => e
    raise PipelineError, "adapter returned invalid JSON: #{e.message}"
  end

  def execute(workflow, inputs, adapter)
    limits = workflow.fetch("limits", {})
    default_timeout = limits.fetch("default_timeout_seconds", 180).to_i
    default_output_limit = limits.fetch("max_step_output_chars", 16_000).to_i
    max_prompt_chars = limits.fetch("max_prompt_chars", 50_000).to_i
    context = inputs.dup
    trace = []

    workflow["steps"].each do |step|
      capture = step["capture"]
      unless condition_met?(step["when"], context)
        context[capture] = fallback_value(step, context).to_s
        trace << {"id" => step["id"], "status" => "skipped", "capture" => capture}
        next
      end

      if step["external"]
        consent_key = step["requires_consent"]
        allowed = context[consent_key] == true && context["contains_sensitive_data"] != true
        unless allowed
          context[capture] = fallback_value(step, context).to_s
          trace << {"id" => step["id"], "status" => "skipped_external", "capture" => capture}
          next
        end
      end

      prompt = render(step["prompt"], context)
      raise PipelineError, "step #{step['id']} prompt exceeds #{max_prompt_chars} characters" if prompt.length > max_prompt_chars
      timeout_seconds = step.fetch("timeout_seconds", default_timeout).to_i
      result = invoke_adapter(adapter, {
        "step_id" => step["id"],
        "skill" => step["skill"],
        "prompt" => prompt,
        "timeout_seconds" => timeout_seconds
      }, timeout_seconds)
      output_limit = step.fetch("max_output_chars", default_output_limit).to_i
      raise PipelineError, "step #{step['id']} output exceeds #{output_limit} characters" if result.length > output_limit
      context[capture] = result
      trace << {"id" => step["id"], "status" => "completed", "capture" => capture, "chars" => result.length}
    rescue PipelineError => e
      if step["on_failure"] == "continue"
        context[capture] = fallback_value(step, context).to_s
        trace << {"id" => step["id"], "status" => "degraded", "error" => e.message, "capture" => capture}
      else
        raise PipelineError, "step #{step['id']} failed: #{e.message}"
      end
    end

    outputs = workflow["outputs"].transform_values { |variable| context.fetch(variable) }
    gate_failures = Array(workflow["gates"]).each_with_object([]) do |gate, failures|
      value = context.fetch(gate["variable"]).to_s
      unless Regexp.new(gate["pattern"]).match?(value)
        failures << {"variable" => gate["variable"], "required_pattern" => gate["pattern"], "message" => gate["message"]}
      end
    end
    {
      "status" => gate_failures.empty? ? "completed" : "blocked",
      "workflow" => workflow["name"],
      "version" => workflow["version"],
      "outputs" => outputs,
      "gate_failures" => gate_failures,
      "trace" => trace
    }
  end
end

def usage
  warn "Usage:"
  warn "  pipeline_runner.rb validate WORKFLOW.yaml"
  warn "  pipeline_runner.rb plan WORKFLOW.yaml [key=value ...]"
  warn "  pipeline_runner.rb run WORKFLOW.yaml --adapter /absolute/path [key=value ...]"
  exit 2
end

if __FILE__ == $PROGRAM_NAME
  command = ARGV.shift || usage
  workflow_path = ARGV.shift || usage

  begin
    workflow = PipelineRunner.load_workflow(workflow_path)
    PipelineRunner.validate!(workflow, workflow_path)

    case command
    when "validate"
      puts JSON.pretty_generate({"status" => "valid", "workflow" => workflow["name"], "version" => workflow["version"]})
    when "plan"
      inputs = PipelineRunner.resolve_inputs(workflow, ARGV)
      steps = workflow["steps"].map do |step|
        enabled = begin
          PipelineRunner.condition_met?(step["when"], inputs)
        rescue PipelineError
          "runtime"
        end
        if enabled == true && step["external"]
          consent = inputs[step["requires_consent"]] == true
          safe = inputs["contains_sensitive_data"] != true
          enabled = consent && safe
        end
        {"id" => step["id"], "skill" => step["skill"], "enabled" => enabled, "external" => !!step["external"]}
      end
      puts JSON.pretty_generate({"workflow" => workflow["name"], "inputs" => inputs, "steps" => steps, "outputs" => workflow["outputs"]})
    when "run"
      adapter_index = ARGV.index("--adapter")
      usage unless adapter_index && ARGV[adapter_index + 1]
      adapter = File.expand_path(ARGV[adapter_index + 1])
      raise PipelineError, "adapter is not executable: #{adapter}" unless File.executable?(adapter)
      args = ARGV.each_with_index.reject { |_, index| index == adapter_index || index == adapter_index + 1 }.map(&:first)
      inputs = PipelineRunner.resolve_inputs(workflow, args)
      puts JSON.pretty_generate(PipelineRunner.execute(workflow, inputs, adapter))
    else
      usage
    end
  rescue PipelineError => e
    warn JSON.generate({"status" => "error", "error" => e.message})
    exit 1
  end
end
