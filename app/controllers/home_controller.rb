# frozen_string_literal: true

class HomeController < ApplicationController
  # GET /
  def index
    @trending = Job.trending
    @latest = Job.latest
  end
end
