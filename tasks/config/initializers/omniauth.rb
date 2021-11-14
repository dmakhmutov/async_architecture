# frozen_string_literal: true

require 'auth_strategy'

Rails.application.config.middleware.use OmniAuth::Builder do
  credentials = Rails.application.credentials
  provider :auth_strategy, credentials.auth_key, credentials.auth_secret, scope: 'public write'
end
