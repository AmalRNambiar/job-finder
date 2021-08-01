# frozen_string_literal: true

class Job
  JOB_KEY = 'jobs'
  CACHE_JOB_KEY = 'cached_job_search'
  STORE_LIMIT = 4

  # return list of jobs from redis
  def self.list(limit = STORE_LIMIT)
    $redis.lrange(JOB_KEY, 0, limit).map do |job|
      JSON.parse(job)
    end
  end

  # push search reasults to redis
  def self.push(jobs:, user_id:)
    broadcast_to_jobs(jobs: jobs, user_id: user_id)
    jobs.each do |job|
      $redis.lpush(JOB_KEY, job.to_json)
    end
  end

  # search query in redis cache before enqueue api call.
  # api returns id of cached jobs
  def self.search_cache(search_key)
    $redis.lrange(CACHE_JOB_KEY, 0, -1).map do |cache|
      c = JSON.parse(cache)
      c if c['search_key'] == search_key && c['expire_at'] > Time.now.to_i
    end.compact.pluck('job_ids').flatten.uniq
  end

  # perform where condition using array od job ids as input
  def self.where(ids: [])
    return nil if ids.empty?

    list(-1).select { |l| ids.include? l['guid'] }
  end

  # find a job using id
  def self.find_by(id:)
    list(-1).select { |l| id == l['guid'] }.first
  end

  # return all jobs from redis
  def self.all
    list(-1)
  end

  # order jobs by updated at
  def self.latest
    list(-1).last(5)
  end

  # when new jobs are returned from background job broad cast to homepage
  def self.broadcast_to_jobs(jobs:, user_id:)
    ActionCable.server.broadcast "jobs_#{user_id}", jobs
  end
end
