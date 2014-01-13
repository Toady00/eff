require 'erb'

module Eff
  class Template
    attr_reader :result, :src

    def initialize(src, erb_vars = {})
      @src          = ERB.new(src)
      self.erb_vars = erb_vars
    end

    def erb_vars=(value)
      @erb_vars = normalize_erb_vars(value)
      interpolate_result
      @erb_vars
    end

  private
    def erb_vars
      @erb_vars
    end

    def interpolate_result
      @result = erb_binding_wrapper do |binding|
        @src.result(binding)
      end
    end

    def erb_binding_wrapper(&block)
      set_erb_vars
      value = yield(binding)
      unset_erb_vars
      value
    end

    def set_erb_vars
      erb_vars.each do |erb_var, value|
        instance_variable_set erb_var, value
      end
    end

    def unset_erb_vars
      erb_vars.each do |erb_var, value|
        remove_instance_variable erb_var
      end
    end

    def normalize_erb_vars(erb_vars)
      Hash[
        erb_vars.to_h.map { |k, v| ["@#{k}".to_sym, v] }
      ]
    end
  end
end
