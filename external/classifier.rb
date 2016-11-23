#!/usr/bin/env ruby
require "json"

Encoding.default_external = "utf-8"
Encoding.default_internal = "utf-8"

data = JSON.parse($stdin.read.encode("utf-8").gsub(/[\t]+/,' '))
data.each do |event|
  event["type"] ||= []
  event["type"] << "Dummy"
end

$stdout.write data.to_json
