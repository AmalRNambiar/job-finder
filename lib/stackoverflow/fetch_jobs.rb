# frozen_string_literal: true

require 'net/http'
module Stackoverflow
  class FetchJobs
    def initialize(key:)
      @url = ENV['STACK_OVERFLOW_URL'] + key.to_s + '&l=' + ENV['DEFAULT_PLACE']
    end

    def perform
      uri = URI(@url)
      response = Net::HTTP.get(uri)
      result = Hash.from_xml(response)['rss']['channel']['item']
      return [] if result.nil?

      result.map do |job|
        { guid: job['guid'], title: job['title'], author: job['author']['name'],
          location: job['location'], description: job['description'],
          published_at: job['pubDate'], updated_at: job['updated'] }
      end
    end
  end
end
