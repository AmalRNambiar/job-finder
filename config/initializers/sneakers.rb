# frozen_string_literal: true

require 'sneakers'

# TODO: change your connection configs
Sneakers.configure connection: Bunny.new(host: 'rabbitmq')
Sneakers.logger.level = Logger::INFO
