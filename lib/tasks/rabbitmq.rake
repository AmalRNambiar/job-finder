# frozen_string_literal: true

namespace :rabbitmq do
  desc 'Connect consumer to producer'
  task :setup do
    require 'bunny'
    conn = Bunny.new.tap(&:start)
    ch = conn.create_channel
    queue_dashboards = ch.queue('dashboards.jobs', durable: true)
    # bind queue to exchange
    queue_dashboards.bind('jobs.stackoverflow')
    conn.close
  end
end
