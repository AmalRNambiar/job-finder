# frozen_string_literal: true

# listen to dashboards.jobs queue which is binded to jobs queue
require 'sneakers'

class JobsWorker
  include Sneakers::Worker
  from_queue :search

  def work(params)
    params = JSON.parse(params)['arguments'].first
    results = Stackoverflow::FetchJobs.new(key: params['key']).perform
    Job.import(jobs: results, user_id: params['user_id'], key: params['key'])
    ack!
  end
end
