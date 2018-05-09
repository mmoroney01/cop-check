require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

config_files = ['application.yml']

    config_files.each do |file_name|
    	my_rails_root = File.expand_path('../..', __FILE__)
      file_path = File.join(my_rails_root, 'config', file_name)
      config_keys = HashWithIndifferentAccess.new(YAML::load(IO.read(file_path)))[Rails.env]
      config_keys.each do |k,v|
        ENV[k.upcase] ||= v
      end
    end


module Copcheck
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.read_encrypted_secrets = true
    config.load_defaults 5.1


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
