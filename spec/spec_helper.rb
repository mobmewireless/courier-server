# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'simplecov'
require 'simplecov-rcov'
require 'fakeweb'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter 'vendor'
  add_filter 'spec'
end if ENV['COVERAGE']

FakeWeb.allow_net_connect = false

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

# Taken from
# http://wincent.com/knowledge-base/Fixtures_considered_harmful%3F
class Hash
  # for excluding keys
  def except(*exclusions)
    self.reject { |key, value| exclusions.include? key.to_sym }
  end

  # for overriding keys
  def with(overrides = {})
    self.merge overrides
  end
end

# Valid attributes for a device
module DeviceSpecHelper
  def valid_device_attributes
    {
        name: 'test_1',
        push_id: 'A157',
        device_type: 'android'
    }
  end
end

# Valid attributes for a message
module MessageSpecHelper
  def valid_message_attributes
    {
        content: {message: 'Sample message', type: 'notification'}.to_json,
        status: 'pending',
    }
  end
end

module DaemonSpecHelper
  def start_daemon_for_x_sec(instance, x)
    begin
      Timeout.timeout(x) { instance.run }
    rescue Timeout::Error
      'Breaking the infinite loop!'
    end
  end
end