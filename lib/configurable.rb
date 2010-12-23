require 'configurable/config'

# This module implements the common logic which is being used for
# configuring modules and/or classes
#
module Configurable

  # Errors module have all custom errors which might be thrown while
  # using the configuration logic

  module Errors
    # The error class which is thrown when config parameter was not
    # defined in the default configuration. All parameters you are
    # going to use as a configuration should be defined in the Class.default_configuration
    class ConfigParamNotFound < Exception; end

    # The error class which is thrown when class has not been
    # configured by default neither with custom settings
    class NotConfigured < Exception; end
  end

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods

    # This method set up the default configuration
    # Nested params are allowed
    #
    # @example
    #   class MyClass
    #     include Configurable
    #
    #     default_configuration({
    #       :param_one => "One",
    #       :param_two => "Two",
    #       :param_three => {
    #         :nested_param => "Three"
    #       }
    #     })
    #   end
    #
    # @param (Hash) config define the default configuration
    #
    # @api public
    def default_configuration(config)
      @config = Config.new(config)
    end

    # This method is being used to overwrite default configuration
    # It raises exceptions when the key does not exist. That means it
    # has not been definbed when Object has been configured by default
    #
    # @example
    #   MyClass.configure do |config|
    #     config.param_one = 1
    #     config.param_two = 2
    #   end
    #
    # @raise [Configurable::Errors::NotConfigured] when
    #   default configuraton does not exist
    #
    # @api public
    def configure(&block)
      if @config.nil?
        raise Errors::NotConfigured, "#{self.name} does not have default configuration" if @config.nil?
      end
      block.call @config
    end

    # Current configuration of the class
    #
    # @example
    #   MyClass.config.param_one                # => "One"
    #   MyClass.config.param_two                # => "Two"
    #   MyClass.config.param_three.nested_param # => "Three"
    #
    # @return [Configurable::Config] Config object
    #
    # @raise [Configurable::Errors::NotConfigured] when @config has
    #   not been defined by default or using #configure method
    #
    # @api public
    def config
      raise Errors::NotConfigured, "#{self.name} is not configured" if @config.nil?
      @config
    end

  end

end
