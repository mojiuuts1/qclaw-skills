#!/usr/bin/env ruby

require "json"

request = JSON.parse($stdin.read)
result = if request.fetch("step_id") == "final-fact-check"
           "发现确认错误。\nFINAL_FACT_STATUS: FAIL"
         else
           "#{request.fetch('step_id')}|#{request.fetch('skill')}|ok"
         end
puts JSON.generate({"result" => result})
