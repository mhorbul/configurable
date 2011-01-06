module Configurable
  class Config

    def initialize(data)
      @data = {}
      update!(data)
    end

    def method_missing(method, *args)
      raise Errors::ConfigParamNotFound, "Configuration parameter #{method} is not found"
    end

    private
    def []=(key, value)
      @data[key.to_sym] = value.is_a?(Hash) ? self.class.new(value) : value
    end

    def [](key)
      @data[key.to_sym]
    end

    def update!(data)
      data.each do |k,v|
        self[k] = v
        self.class.class_eval do
          define_method(k.to_sym) { self[k] } # def foo; self[foo]; end
          define_method("#{k}=".to_sym) { |v| self[k] = v } # def foo=(v); self[foo]=v; end
        end
      end
    end
  end
end
