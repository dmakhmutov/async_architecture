# frozen_string_literal: true

require 'auth_strategy'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth_strategy, ENV["AUTH_KEY"], ENV["AUTH_SECRET"], scope: 'public write'
  # provider :auth_strategy, '5dVD9cUTtJ1SrEZvH4WzH_0yIqROby2oinZX9LxtlPM', 'S8NJFcUsZaSKb4ST3231UiRdHmNhs7d8OV0l8GvvFpk', scope: 'public write'
end
