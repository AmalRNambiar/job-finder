# frozen_string_literal: true

json.array! @jobs do |job|
  json.guid job.guid
  json.title job.title
  json.author job.author
end
