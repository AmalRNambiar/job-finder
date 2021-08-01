# frozen_string_literal: true

# listen to dashboards.jobs queue which is binded to jobs queue
require 'sneakers'

class JobsWorker
  include Sneakers::Worker

  from_queue 'dashboards.jobs', env: nil

  def work(jobs)
    Job.push(jobs: jobs, user_id: nil)
    ack!
  end
end
