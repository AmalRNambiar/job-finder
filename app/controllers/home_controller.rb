# frozen_string_literal: true

class HomeController < ApplicationController
  # GET /
  def index
    @trending_jobs = Job.list
    @latest_jobs = Job.latest
  end
end
