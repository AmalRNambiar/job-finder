# frozen_string_literal: true

class Job < ApplicationRecord
  CACHE_JOB_KEY = 'cached_job_search'
  EXPIRE_CACHE = 5.minutes
  STORE_LIMIT = 10_000

  scope :latest, -> { order(published_at: :desc).limit(5) }
  scope :trending, -> { order(updated_at: :asc).limit(5) }

  # api returns id of cached jobs
  def self.search_cache(search_key)
    $redis.lrange(CACHE_JOB_KEY, 0, -1).map do |cache|
      c = JSON.parse(cache)
      c if c['search_key'] == search_key && c['expire_at'] > Time.now.to_i
    end.compact.pluck('job_ids').flatten.uniq
  end

  def self.import(jobs:, user_id:, key:)
    unless jobs.blank?
      # add to cache
      upsert_all(jobs)
      job_ids = jobs.pluck(:guid)
      cache = { search_key: key, job_ids: job_ids, expire_at: EXPIRE_CACHE.from_now.to_i }
      $redis.lpush(CACHE_JOB_KEY, cache.to_json)
      $redis.ltrim(CACHE_JOB_KEY, 0, STORE_LIMIT - 1)
    end
    # broadcast to homepage
    broadcast_to_jobs(jobs: jobs, user_id: user_id)
  end

  def self.broadcast_to_jobs(jobs:, user_id:)
    ActionCable.server.broadcast "jobs_#{user_id}", { jobs: jobs }
  end
end
