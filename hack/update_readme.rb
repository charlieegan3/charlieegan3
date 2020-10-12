#!/usr/bin/env ruby

require 'erb'
require 'net/http'
require 'uri'
require 'json'
require 'time'

def load_status
  uri = URI.parse("https://charlieegan3.github.io/json-charlieegan3/build/status.json")
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body).sort_by { |_, v| v["created_at"] }.reverse
end

templates = {}

templates["tweet"] = <<-MD.chomp
* 🐦 [Tweet](<%= data["link"] %>) <sub><sup><%= data["created_at_string"] %></sub></sup>
  > <%= data["text"] %>
MD
templates["post"] = <<-MD.chomp
* 📸 [<%= data["location"] %>](<%= data["url"] %>) <sub><sup><%= data["created_at_string"] %></sub></sup>
MD
templates["activity"] = <<-MD.chomp
* 🎽 [Strava activity](<%= data["url"] %>) <sub><sup><%= data["created_at_string"] %></sub></sup>
  > <%= data["name"] %>
MD
templates["film"] = <<-MD.chomp
* 📽️ Watched [<%= data["title"] %>](<%= data["link"] %>) <sub><sup><%= data["created_at_string"] %></sub></sup>
MD
templates["commit"] = <<-MD.chomp
* 💻 [Public commit](<%= data["url"] %>) <sub><sup><%= data["created_at_string"] %></sub></sup>
<%= data["message"].split("\n").map { |e| "  > \#{e}" }.join("\n") %>
MD
templates["play"] = <<-MD.chomp
* 🎧 [_"<%= data["track"] %>"_ by _<%= data["artist"] %>_](https://music.charlieegan3.com) <sub><sup><%= data["created_at_string"] %></sub></sup>
MD


template = <<-HTML.chomp

Welcome to my GitHub profile! <%= time %>

My main home is [charlieegan3.com](https://charlieegan3.com) but here's my latest news:

<%
  data.each do |k, v|
  data = v
%>
<%= ERB.new(templates[k]).result() %> <% end %>

HTML


max_retries = 5
retries = 0
data = nil

begin
  data = load_status
rescue Exception => e
  puts "Retrying... (#{e.message})"
  if retries <= max_retries
    retries += 1
    sleep 3 ** retries
    retry
  else
    raise "Timeout: #{e.message}"
  end
end


# who likes BST anyway...
case Time.now.utc.hour
when 0..8
  time = "🌌"
when 22..23
  time = "🌃"
when 9..12
  time = "🌄"
when 13..17
  time = "🌤️"
when 18..21
  time = "🌆"
end

content = ERB.new(template).result()
File.write("README.md", content)
