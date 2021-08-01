# frozen_string_literal: true

# seed jobs to show in dashboard
SearchJob.perform_now(key: 'Engineer', user_id: 'seed')
