#!/usr/bin/env ruby

require "json"

request = JSON.parse($stdin.read)
sleep 1 if request["prompt"].include?("__SLOW__")
result = if request.fetch("step_id") == "final-fact-check"
           "final-fact-check|fact-check|ok\nFINAL_FACT_STATUS: PASS"
         else
           "#{request.fetch('step_id')}|#{request.fetch('skill')}|ok"
         end
puts JSON.generate({"result" => result})
