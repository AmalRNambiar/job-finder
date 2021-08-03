# frozen_string_literal: true

class JobsController < ApplicationController
  # GET /jobs/:id
  def show
    @job = Job.find_by(guid: params[:id])
  end
end
