#!/usr/bin/env ruby
require "json"

data = JSON.parse($stdin.read)
data.each do |event|
  event["type"] << "Dummy"
end

$stdout.write data.to_json
