require "minitest/autorun"
require_relative "../scripts/pipeline_runner"

class PipelineRunnerTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  QUALITY = File.join(ROOT, "workflows", "quality.yaml")
  ADAPTER = File.join(__dir__, "fake_adapter.rb")
  FAILING_FACT_ADAPTER = File.join(__dir__, "failing_fact_adapter.rb")

  def setup
    @workflow = PipelineRunner.load_workflow(QUALITY)
  end

  def test_quality_workflow_validates
    assert PipelineRunner.validate!(@workflow, QUALITY)
  end

  def test_chinese_aliases_and_booleans
    inputs = PipelineRunner.resolve_inputs(@workflow, [
      "问题=测试",
      "包含工具=否",
      "允许外部审查=是"
    ])
    assert_equal "测试", inputs["question"]
    assert_equal false, inputs["include_tools"]
    assert_equal true, inputs["allow_external_review"]
  end

  def test_unknown_input_is_rejected
    error = assert_raises(PipelineError) do
      PipelineRunner.resolve_inputs(@workflow, ["question=测试", "unknown=x"])
    end
    assert_match "unknown input", error.message
  end

  def test_end_to_end_with_optional_steps_skipped
    inputs = PipelineRunner.resolve_inputs(@workflow, [
      "question=测试",
      "include_failure_analysis=false",
      "include_tools=false",
      "allow_external_review=false"
    ])
    result = PipelineRunner.execute(@workflow, inputs, ADAPTER)
    assert_equal "completed", result["status"]
    assert_equal "factual-correction|recursive-ai|ok", result.dig("outputs", "primary")
    assert_match "FINAL_FACT_STATUS: PASS", result.dig("outputs", "evidence")
    statuses = result["trace"].to_h { |entry| [entry["id"], entry["status"]] }
    assert_equal "skipped", statuses["failure-mode-analysis"]
    assert_equal "skipped", statuses["tool-stack-recommendation"]
    assert_equal "skipped", statuses["adversarial-review"]
  end

  def test_external_review_runs_only_with_consent_and_no_sensitive_data
    allowed = PipelineRunner.resolve_inputs(@workflow, [
      "question=测试",
      "allow_external_review=true",
      "contains_sensitive_data=false"
    ])
    allowed_result = PipelineRunner.execute(@workflow, allowed, ADAPTER)
    allowed_status = allowed_result["trace"].find { |entry| entry["id"] == "adversarial-review" }
    assert_equal "completed", allowed_status["status"]

    blocked = PipelineRunner.resolve_inputs(@workflow, [
      "question=测试",
      "allow_external_review=true",
      "contains_sensitive_data=true"
    ])
    blocked_result = PipelineRunner.execute(@workflow, blocked, ADAPTER)
    blocked_status = blocked_result["trace"].find { |entry| entry["id"] == "adversarial-review" }
    assert_equal "skipped_external", blocked_status["status"]
  end

  def test_adapter_timeout
    error = assert_raises(PipelineError) do
      PipelineRunner.invoke_adapter(ADAPTER, {
        "step_id" => "slow",
        "skill" => "test",
        "prompt" => "__SLOW__"
      }, 0.05)
    end
    assert_match "timed out", error.message
  end

  def test_missing_capture_reference_is_rejected
    broken = Marshal.load(Marshal.dump(@workflow))
    broken["steps"][1]["prompt"] = "{{ never_created }}"
    error = assert_raises(PipelineError) do
      PipelineRunner.validate!(broken, QUALITY)
    end
    assert_match "unavailable variable", error.message
  end

  def test_output_limit_fails_visibly
    limited = Marshal.load(Marshal.dump(@workflow))
    limited["steps"][0]["max_output_chars"] = 5
    inputs = PipelineRunner.resolve_inputs(limited, [
      "question=测试",
      "include_failure_analysis=false",
      "include_tools=false"
    ])
    error = assert_raises(PipelineError) do
      PipelineRunner.execute(limited, inputs, ADAPTER)
    end
    assert_match "output exceeds", error.message
  end

  def test_failed_final_fact_gate_blocks_completion
    inputs = PipelineRunner.resolve_inputs(@workflow, [
      "question=测试",
      "include_failure_analysis=false",
      "include_tools=false"
    ])
    result = PipelineRunner.execute(@workflow, inputs, FAILING_FACT_ADAPTER)
    assert_equal "blocked", result["status"]
    assert_equal "corrected_output", @workflow.dig("outputs", "primary")
    assert_equal 1, result["gate_failures"].length
    assert_match "不得把 primary", result.dig("gate_failures", 0, "message")
  end
end
