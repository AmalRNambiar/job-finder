# frozen_string_literal: true

class JobsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "jobs_#{current_user}"
  end
end
