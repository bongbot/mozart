# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path('../boot', __FILE__)

require 'rubygems'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# require "rails/test_unit/railtie"
#
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Override Rails Engines so that plugins have higher priority than the Application
require 'fat_free_crm/gem_ext/rails/engine'

module FatFreeCRM

  class Application < Rails::Application

    # Travis-ci: remove tenant-aparment code for simple testing
    unless ENV["TRAVIS_CI"] == "true"
      require 'apartment/elevators/generic' # or 'domain' or 'generic'
      config.middleware.use 'Apartment::Elevators::Generic', Proc.new {     |request|
                              if request.host.split(".").length >= 2 && request.host.split(".").length < 4
                                request.host.split(".")[0]
                              else
                                config   = Rails.configuration.database_configuration
                                config[Rails.env]["database"]
                              end
                                                           }
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Models are organized in sub-directories
    config.autoload_paths += Dir[Rails.root.join("app/models/**")] +
                             Dir[Rails.root.join("app/controllers/entities")] +
                             Dir[Rails.root.join("app/controllers/entities/extends")]
    config.autoload_paths += %W(#{config.root}/lib)

    # Prevent Field class from being reloaded more than once as this clears registered customfields
    config.autoload_once_paths += [File.expand_path("../app/models/fields/field.rb", __FILE__)]

    # Activate observers that should always be running.
    unless ARGV.join.include?('assets:precompile')
      config.active_record.observers = :lead_observer, :opportunity_observer, :task_observer, :entity_observer
    end

    # Load development rake tasks (RSpec, Gem packaging, etc.)
    rake_tasks do
      Dir.glob(Rails.root.join('lib', 'development_tasks', '*.rake')).each { |t| load t }
    end

    # Add migrations from all engines
    # Railties.engines.each do |engine|
    #   # config.paths['db/migrate'] += engine.paths['db/migrate'].existent
    # end

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_hash, :password_salt, :password_confirmation]

    config.active_record.raise_in_transactional_callbacks = true
  end
end

# Require fat_free_crm after FatFreeCRM::Application class is defined,
# so that FatFreeCRM::Engine is skipped.
require 'fat_free_crm'

db_conf =  Rails.configuration.database_configuration
MOZART_SASS = db_conf["mozart_sass"][ENV['RAILS_ENV']]
