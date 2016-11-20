#!/usr/bin/env ruby
require "json"

data = JSON.parse($stdin.read.gsub(/[\t]+/,' '))
data.each do |event|
  event["type"] ||= []
  event["type"] << "Dummy"
end

$stdout.write data.to_json
