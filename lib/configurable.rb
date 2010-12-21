# This module implements the common logic which is being used for
# configuring modules and/or classes
#
module Configurable

  # Errors module have all custom errors which might be thrown while
  # using the configuration logic

  module Errors
    # The error class which is thrown when default configuraiton does
    # not exist
    class DefaultConfigNotExists < Exception; end

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
    #
    # @example
    #   class MyClass
    #     include Configurable
    #
    #     default_configuration({
    #       :param_one => "One",
    #       :param_two => "Two"
    #     })
    #   end
    #
    # @param (Hash) config define the default configuration
    # @api public
    def default_configuration(config)
      @config = config
    end

    # This method is being used to overwrite default configuration
    #
    # @example
    #   MyClass.configure({
    #     :param_one => 1,
    #     :param_two => 2
    #   })
    #
    # @raise [Configurable::Errors::DefaultConfigNotExists] when
    #   default configuraton does not exist
    # @raise [Configurable::Errors::ConfigParamNotFound] when provided
    #   config has keys which do not exist in the default configuration
    # @api public
    def configure(config)
      if @config.nil?
        raise Errors::DefaultConfigNotExists, "#{self.name} does not have default configuration"
      end
      unknown_keys = config.keys - @config.keys
      unless unknown_keys.empty?
        raise Errors::ConfigParamNotFound, "Configuration parameters #{unknown_keys.inspect} are not found"
      end
      # merge default config with the provided one
      @config.merge!(config)
    end

    # Current configuration of the class
    #
    # @example
    #   MyClass.config[:param_one] # => "one"
    #   MyClass.config[:param_two] # => "two"
    #
    # @return [Hash] configuration of the class
    # @raise [Configurable::Errors::NotConfigured] when @config has
    #   not been defined by default or using #configure method
    # @api public
    def config
      raise Errors::NotConfigured, "#{self.name} is not configured" if @config.nil?
      @config
    end

  end

end
