# frozen_string_literal: true

# listen to dashboards.jobs queue which is binded to jobs queue
require 'sneakers'

class JobsWorker
  include Sneakers::Worker
  from_queue :search
  EXPIRE_CACHE = 5
  CACHE_JOB_KEY = 'cached_job_search'
  STORE_LIMIT = 10_000

  def work(params)
    params = JSON.parse(params)['arguments'].first
    key = params['key']
    user_id = params['user_id']

    results = Stackoverflow::FetchJobs.new(key: key).perform
    if results.blank?
      ActionCable.server.broadcast "jobs_#{user_id}", data: { jobs: [] }
    else
      cache = { search_key: key, job_ids: results.pluck('guid'),
                expire_at: EXPIRE_CACHE.to_i.minutes.from_now.to_i }
      $redis.lpush(CACHE_JOB_KEY, cache.to_json)
      $redis.ltrim(CACHE_JOB_KEY, 0, STORE_LIMIT - 1)
      Job.push(jobs: results, user_id: user_id)
    end
    ack!
  end
end
