COURIER_CONFIG = {
  gcm_project_number: ENV['COURIER_GCM_PROJECT_NUMBER'],
  gcm_api_key: ENV['COURIER_GCM_API_KEY'],
  allowed_users: ENV['COURIER_ALLOWED_USERS'].split(',')
}.with_indifferent_access
