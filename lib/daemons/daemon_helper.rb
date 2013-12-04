ROOT_PATH = File.absolute_path(File.join(File.dirname(__FILE__), '..', '..'))
$stdout.sync = true

require 'logger'
require 'active_record'
require 'higcm'
require 'json'
require 'erb'

require_relative '../../app/models/device'
require_relative '../../app/models/message'
require_relative '../../config/initializers/courier_config'

def connect_db!
  rails_env = ENV['RAILS_ENV'] || 'development'
  unless rails_env == 'test'
    db_params = YAML.load(ERB.new(File.read(File.join(ROOT_PATH, 'config', 'database.yml'))).result)[rails_env]
    ActiveRecord::Base.establish_connection(db_params)
  end
end