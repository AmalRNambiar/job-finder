# frozen_string_literal: true

class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    # check in cached jobs
    cached_job_ids = Job.search_cache(params[:query])
    if cached_job_ids.present?
      @jobs = Job.where(ids: cached_job_ids)
    else
      SearchJob.perform_later(key: params[:query], user_id: @user_id)
    end
  end
end
