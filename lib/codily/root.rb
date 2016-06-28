require 'fastly'
require 'codily/elements/service'

module Codily
  class Root
    class AlreadyDefined < StandardError; end

    def initialize
      @elements = {}
    end

    attr_reader :elements

    def services
      list_element(Elements::Service)
    end

    def service(name, &block)
      raise AlreadyDefined if services.key?(name)
      add_element(Elements::Service.new(self, {name: name}, &block))
    end


    def run_block(&block)
      raise ArgumentError, 'block not given' unless block

      instance_eval &block
      self
    end

    def run_string(str, file = '(eval)', line = 1)
      instance_eval str, file, line
      self
    end


    def add_element(element)
      h = (@elements[element.class.name] ||= {})
      raise AlreadyDefined, "#{element.class.name}(#{element.key}) is already defined: (#{h.keys.inspect})" if h.key?(element.key)
      h[element.key] = element
    end

    def list_element(klass_or_name)
      key = case klass_or_name
            when Class
              klass_or_name.name
            when String
              klass_or_name
            end
      @elements[key] ||= {}
    end
  end
end
