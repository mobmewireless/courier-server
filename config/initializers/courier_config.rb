COURIER_CONFIG = {
  gcm_project_number: ENV['GOOGLE_PROJECT_NUMBER'],
  gcm_api_key: ENV['GOOGLE_SERVER_KEY'],
  allowed_users: ENV['COURIER_ALLOWED_USERS'].split(',')
}.with_indifferent_access
