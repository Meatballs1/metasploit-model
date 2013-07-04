#
# Core
#
require 'shellwords'

#
# Gems
#
require 'active_support'
require 'active_support/all'
require 'active_support/dependencies'

#
# Project
#
require 'metasploit_data_models/base64_serializer'
require 'metasploit_data_models/models'
require 'metasploit_data_models/version'
require 'metasploit_data_models/serialized_prefs'

# Only include the Rails engine when using Rails.  This allows the non-Rails projects, like metasploit-framework to use
# the models by calling MetasploitDataModels.require_models.
if defined? Rails
  require 'metasploit_data_models/engine'
end

# Namespace module for the metasploit_data_models gems.
module MetasploitDataModels
  extend MetasploitDataModels::Models

  # Pathname to the app directory that contains the models and validators.
  #
  # @return [Pathname]
  def self.app_pathname
    root.join('app')
  end

  # Pathname to the top of the metasploit_data_models gem's files.
  #
  # @return [Pathname]
  def self.root
    unless instance_variable_defined? :@root
      lib_pathname = Pathname.new(__FILE__).dirname

      @root = lib_pathname.parent
    end

    @root
  end
end

lib_pathname = MetasploitDataModels.root.join('lib')
# has to work under 1.8.7, so can't use to_path
lib_path = lib_pathname.to_s
# Add path to gem's lib so that concerns for models are loaded correctly if models are reloaded
ActiveSupport::Dependencies.autoload_paths << lib_path
ActiveSupport::Dependencies.autoload_once_paths << lib_path
