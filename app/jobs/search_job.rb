# frozen_string_literal: true

class SearchJob < ApplicationJob
  queue_as :search
end
