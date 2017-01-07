source 'https://rubygems.org'

gem 'rails', '~>4.1.1'

# HTTP Related
gem 'unicorn' #unicorn is used for online development enviornment, staging, demo, and production environments
gem 'secure_headers' #Addes various HTTP headers to enhance security. See https://github.com/twitter/secureheaders

# ### Depcreated gems no longer used.
#gem "auto_strip_attributes", "~> 2.0"  #Using attribute_normalizer instead.
#gem 'linkedin-scraper' Removed as this violates LinkedIn agrreement and gets us blocked.
#gem 'strong_parameters' #baked into Rails 4.x
#gem "urlify" #converts text strings to ASCII-safe URIs Ommitted now, use Rails built-in parameterize method instead.
#gem 'rabl'  ActiveModel serializers should be used instead of RABL for this project.
#gem 'bootstrap_forms'  Removed and replaced with simple_forms gem which does this and more.
#gem 'yajl-ruby', :require => "yajl"  # Using oj gem instead #json parsing library, see https://github.com/brianmario/yajl-ruby
#gem 'rails3-jquery-autocomplete', '~> 1.0.12'  #unused
#gem 'jquery_datepicker' #unused
#gem 'hpricot'  #unused
#gem "font-awesome-rails" #unused, moved to using a CDN, avoids deployment issues. #vendors font-awesome, see: https://github.com/bokmann/font-awesome-rails
#gem "asset_sync", #not used, GH's own code is used for this #provides a way to place assets in S3 buckets for deployment: see, https://github.com/rumblelabs/asset_sync
# The following 6 gems removed from use on 07-01-2014 with the full removal of HAML support along with removing the need for pluggable and gon.
#gem 'haml_coffee_assets'
#gem "nokogiri", "~> 1.5" #provides HTML/XML/SAX parsing
#gem 'haml'
#gem 'gon', '~> 4.0.3' #Simple way to make Rails variables available in JS/Coffeescript, see: https://github.com/gazay/gon
#gem 'pluggable_js' #provides functionality of loading page specific javascript, see: https://github.com/peresleguine/pluggable_js
#gem 'coffeebeans'
#gem "nifty-generators", require: false  # Just not needed per JL on 2014-07-06
#gem 'awesome_nested_set' #provides handling for nested lists (for traits/sub-traits), see: https://github.com/collectiveidea/awesome_nested_set



# Database and model related
gem 'mysql2'
gem 'schema_plus' #provides for DDL level foreign key implementation, see: https://github.com/lomba/schema_plus
gem 'sentient_user' #provides for intelligent user stamping, see: https://github.com/bokmann/sentient_user
gem 'acts_as_list'
gem 'paranoia', '~> 2.0' #provides for 'soft' delete functionality using .deleted_at column, see: https://github.com/radar/paranoia
gem 'attribute_normalizer' #Stips white space and helps to normalize attributes to expected formats. see: https://github.com/mdeering/attribute_normalizer
gem 'deep_cloneable', '~> 1.6.0' #Provides deep object copying ability allowing for copying of 'template' accounts or context objects, see: https://github.com/moiristo/deep_cloneable
gem 'email_validator'
gem 'validates_timeliness', '~> 3.0' #provides validation for dates, see: https://github.com/adzap/validates_timeliness/
gem 'activerecord-typedstore' # Better ActiveRecord::Store implementation.
#gem 'enumerize' #provides stronger enum types for our active record classes, see: https://github.com/brainspec/enumerize
gem 'simple_enum'

# Routing & Controller related
gem 'friendly_id', '~> 5.0' # Allows the use of SLUGS in place of object ids.  5.0 used for Rails 4.x
gem 'versionist' #provides nice API versioning and controller handling and pathing.
gem 'has_scope' #, git: "https://github.com/plataformatec/has_scope.git"#'0.6.0.rc'


# See javascript related section for js-routes
# Authentication, authorization, and user related
gem 'devise', '~> 3.2'
gem 'devise-encryptable'
gem 'devise_invitable', '~> 1.3.4'
gem 'omniauth'
gem 'omniauth-linkedin-oauth2'
gem 'rest-client'  # Provides library used to fetch data from LinkedIn using oAuth 2.0, see: https://github.com/rest-client/rest-client
gem 'cancan' #provides ability based authorization.
gem 'country_select'  #provides a country_select helper and ISO list of countries.  This is in-leui of maintaining our own country table.
gem 'localized_language_select' #provides a language_select helper and ISO list of languages.  This is in-leui of maintaing our own language table., see: https://github.com/davec/localized_language_select
gem 'bcrypt-ruby', '~> 3.1.2' # Use ActiveModel has_secure_password


# Communication, Cloud, & File transfer related
gem 'fog'
gem 'carrierwave'
gem 'mini_magick'
gem 'aws-sdk'

# View, API Output, & template layer related
gem "active_model_serializers"
gem 'slim'
gem 'slim-rails', '2.1.5'
gem 'oj' #super fast JSON parser library to use instead of yajl
gem 'simple_form' #Provides much cleaner form building and integrates with Bootstrap well.
gem 'draper', '~> 1.3' #Use this for implementing Presenter pattern for standard Rails views. see: https://github.com/drapergem/draper
gem 'responders' #Provides a convenient and fast way to define flash messages by action, see: https://github.com/plataformatec/responders
gem 'kaminari' #pagination helper
gem 'liquid' #simple templating engine used for templating email and notification content, see: http://liquidmarkup.org


# Javascript related
gem 'jquery-rails'
gem 'jquery-rails-cdn'
gem 'jquery-ui-rails'
gem "js-routes"
gem 'angularjs-rails' #vendors angularjs into the project, see: https://github.com/hiravgandhi/angularjs-rails
gem 'angular-rails-templates', github: 'blackxored/angular-rails-templates', branch: 'slim-rails-2.1.5-fix'


# Configuration related
gem 'dotenv-rails' #Provides externalization of environment config values like keys and passwords so they are not stored in SCM. see: https://github.com/bkeepers/dotenv
gem "rails-settings-cached", "~> 0.4.1"
gem 'foreman', '~> 0.74.0', require: false #Used to create daemons out of rake tasks as well as to make upstart scripts.

# Support for items usually found in the asset pipeline.
gem "bower-rails", "~> 0.7.2" #allows for easy integration of js libraries, see: https://github.com/42dev/bower-rails
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.1.1'  # Vendors Bootstrap 3 as SASS.
gem 'bootstrap_flash_messages' #Implements bootstrap flash components, easily replaces Rails flash messages. see: https://github.com/RobinBrouwer/bootstrap_flash_messages
gem 'coffee-rails', '~> 4.0.0' # Use CoffeeScript for .js.coffee assets and views
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
gem 'execjs'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

# Project setup related
gem 'seedbank', require: true  #Must be true otherwise it never loads.  Must be available to all environments in order for Capistrano to seed any enviro.

group :demo, :staging, :production do
  gem 'dalli'  #Provides memcached handling for caching
end

group :development, :test do
  gem 'rspec-rails', require: false #required in both dev and test groups
end


group :development do
  gem 'thin'
  gem 'ruby_parser'
  gem 'bullet'
  gem 'binding_of_caller'
  gem "better_errors"
  gem "quiet_assets"
  gem "awesome_print"
  gem 'pry'
  gem "version", require: false  #provides a nice way to version application, see https://github.com/stouset/version
  gem "spring" #Spring is a Rails application preloader. It speeds up development by keeping your application running in the background, see: https://github.com/rails/spring

  # Deployment related gems
  gem 'capistrano', '~> 3.2.0', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-rails-collection', require: false
  gem 'cap-deploy-tagger', require: false
  gem 'capistrano3-unicorn', require: false


  # Security scanning
  gem 'codesake-dawn', require: false #Scans codebase for security vulnerabilities.  See: https://github.com/codesake/codesake-dawn
  gem 'tarantula', require: 'tarantula-rails3' #Attempts to break application with bad data. see: https://github.com/relevance/tarantula
  # On 2014-Mar-23 brakeman gems commented out due to "tilt" conflict
  #gem 'brakeman', :require => false #Security scanner which checks application for security vulnerabilities. see: https://github.com/presidentbeef/brakeman
  #gem 'guard-brakeman', :require => false #used with brakeman for continuous scanning. see: https://github.com/guard/guard-brakeman

  # Profiling
  # Its defaulted to hidden, to turn on use Hotkey in browser to toggle visibility is Alt-P
  # mini-profiler turned off temporarily to ease inspection of HTML output on 6-12-2014 by JL.
  # gem 'rack-mini-profiler' #Provides a small profiler during requests, see: https://github.com/MiniProfiler/rack-mini-profiler

  platform :mri do
    gem 'rails_best_practices'
  end

  # To use debugger
  # gem 'debugger'
end

group :test do
  gem 'capybara' #simulates how a real-user would interact with the app.
  gem 'poltergeist' #provides headless brower-based testing for Capybara, see: https://github.com/jonleighton/poltergeist
  gem 'guard-rspec' #allows to automatically & intelligently launch specs when files are modified
  gem 'factory_girl', "~> 4.0" #a replacement for standard fixtures for testing, can be used with faker, see: http://viccode.blogspot.com/2010/12/using-factorygirl-and-faker.html
  gem 'factory_girl_rails',  "~> 4.0" #a fixtures replacement with a straightforward definition syntax, support for multiple build strategies. see https://github.com/thoughtbot/factory_girl_rails
  gem 'faker' #makes it easy to provide fake data for testing, see: https://github.com/stympy/faker
  gem "database_cleaner" #provides database manipulation services for tests, see: https://github.com/bmabey/database_cleaner
  gem 'fuubar' # RSpec formatter
  gem 'shoulda-matchers', '~> 2', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

platforms :rbx do
  gem 'psych'
end

