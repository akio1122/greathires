# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'factory_girl'
require 'database_cleaner'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# TODO: revisit
DEFAULT_HOST = "lvh.me"
DEFAULT_PORT = 9887
Capybara.default_host = "http://#{DEFAULT_HOST}"
Capybara.server_port = DEFAULT_PORT
Capybara.app_host = "http://#{DEFAULT_HOST}:#{Capybara.server_port}"
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: false,
    timeout: 120,
    debug: false,
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    inspector: true
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include Requests::JsonHelpers, type: :request
  config.include FactoryGirl::Syntax::Methods # TODO: revisit
  config.include Devise::TestHelpers, type: :controller # TODO: revisit
  config.include Warden::Test::Helpers, type: :request # TODO: revisit
  config.include AttributeNormalizer::RSpecMatcher

  config.render_views # TODO: revisit

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:each, group: :api) do
    # TODO: revisit, at least extract
    # clear instance variable
    Role.instance_variable_set :@account_manager, nil
    Role.instance_variable_set :@account_user, nil
    RolePermission.instance_variable_set :@global_permission_role_mapping, nil
    Permission.instance_variable_set :@for_account, nil
    Permission.instance_variable_set :@for_job, nil
  end

  # TODO: revisit
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end
