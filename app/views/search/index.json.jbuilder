# frozen_string_literal: true

json.array! @jobs do |job|
  json.id job['guid']
  json.name job['title']
  json.author job['author']['name']
end
