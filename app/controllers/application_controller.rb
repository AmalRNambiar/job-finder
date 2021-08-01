# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user_id

  private

  # set unique identifier to user
  def set_user_id
    @user_id = session.id.to_s
  end
end
