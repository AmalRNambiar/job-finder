# frozen_string_literal: true

class SearchJob < ApplicationJob
  queue_as :search
  EXPIRE_CACHE = 10
  CACHE_JOB_KEY = 'cached_job_search'
  STORE_LIMIT = 10_000

  def perform(key:, user_id:)
    results = Stackoverflow::FetchJobs.new(key: key).perform
    if results.blank?
      ActionCable.server.broadcast 'jobs', data: { jobs: [] }
    else
      cache = { search_key: key, job_ids: results.pluck('guid'),
                expire_at: EXPIRE_CACHE.to_i.minutes.from_now.to_i }
      $redis.lpush(CACHE_JOB_KEY, cache.to_json)
      $redis.ltrim(CACHE_JOB_KEY, 0, STORE_LIMIT - 1)
      Job.push(jobs: results, user_id: user_id)
      # publish_to_dashboard(results.to_json)
    end
  end

  def publish_to_dashboard(results)
    Publisher.publish('stackoverflow', results)
  end
end
