module Configurable
  class Config

    def initialize(data)
      @data = {}
      update!(data)
    end

    def method_missing(method, *args)
      if method.match(/(.+)=$/)
        self[$1] = args.first
      else
        self[method]
      end
    end

    private
    def []=(key, value)
      validate_key!(key.to_sym)
      @data[key.to_sym] = value.is_a?(Hash) ? self.class.new(value) : value
    end

    def [](key)
      validate_key!(key.to_sym)
      @data[key.to_sym]
    end

    def update!(data)
      data.each { |k,v| self[k] = v }
      lock!
    end

    def lock!
      @lock = true
    end

    def locked?
      @lock == true
    end

    def validate_key!(key)
      if locked? && !@data.keys.include?(key)
        raise Errors::ConfigParamNotFound, "Configuration parameter #{key} is not found"
      end
    end
  end
end
