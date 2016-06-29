require 'fastly'
require 'codily/utils'

module Codily
  module Elements
    class Base
      class AlreadyDefined < StandardError; end

      def self.def_attr(*attrs)
        attrs.each do |attr|
          define_method(attr) do |obj = nil|
            getset attr, obj
          end
        end
      end

      def self.defaults(kv = nil)
        if kv
          @defaults = defaults.merge(kv)
        else
          @defaults ||= {}
        end
      end

      def initialize(root, obj, &block)
        @root = root

        case obj
        when Hash
          @hash = obj
        when Fastly::Base
          @fastly_obj = obj
          @hash = Utils.symbolize_keys(obj.as_hash)

          @hash.delete :id
          @hash.each_key do |k|
            @hash.delete k if @hash[k].nil?
          end
        else
          raise TypeError
        end

        instance_eval(&block) if block

        setup
      end

      attr_reader :root
      attr_accessor :fastly_obj

      def id
        fastly_obj && fastly_obj.id
      end

      def name(str = nil)
        getset :name, str
      end

      def key
        name
      end

      def as_hash
        self.class.defaults.merge @hash
      end

      private

      def getset(key, obj)
        if obj.nil?
          @hash[key]
        else
          raise AlreadyDefined if @hash.key?(key)
          @hash[key] = obj
        end
      end

      def add(key, obj)
        @hash[key] ||= []
        @hash[key] << obj
      end

      def add_element(key, klass, obj = {}, key2 = :name, &block)
        element = klass.new(root, obj, &block)
        root.add_element(element)
        add(key, element.__send__(key2))
      end

      def add_refer_element(key, klass, obj = {}, key2 = :name, &block)
        elem = refer_element(klass, obj, key2, &block)
        add(key, elem.__send__(key2))
      end

      def set_refer_element(key, klass, obj = {}, key2 = :name, &block)
        elem = refer_element(klass, obj, key2, &block)
        getset(key, elem.__send__(key2))
      end

      def refer_element(klass, obj, key2, &block)
        list = root.list_element(klass)
        element = klass.new(root, obj, &block)
        element_query = element.__send__(key2)
        candidate = list.each_value.find { |_| _.__send__(key2) == element_query }
        if candidate
          if block
            raise AlreadyDefined
          end
        else
          root.add_element(element)
        end

        candidate || element
      end

      def setup
      end

      private

      def delete_if_empty!(*keys)
        keys.each do |k|
          @hash.delete k if @hash[k] && @hash[k].empty?
        end
      end

      def force_integer!(*keys)
        keys.each do |k|
          if @hash[k]
            @hash[k] = @hash[k].to_i
          end
        end
      end
    end
  end
end
