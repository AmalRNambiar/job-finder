# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = setcurrent_user
    end

    private

    def setcurrent_user
      cookies.encrypted[:current_user]
    end
  end
end
