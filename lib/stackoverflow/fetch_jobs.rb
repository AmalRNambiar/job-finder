# frozen_string_literal: true

require 'net/http'

class Stackoverflow::FetchJobs
  def initialize(key:)
    @url = ENV['STACK_OVERFLOW_URL'] + key.to_s + '&l=' + ENV['DEFAULT_PLACE']
  end

  def perform
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    result = Hash.from_xml(response)
    result['rss']['channel']['item']
  end
end
