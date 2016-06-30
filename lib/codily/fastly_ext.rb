require 'fastly'

class Fastly::RequestSetting
  attr_accessor :timer_support
end

module Codily
  module FastlyExt
    def initialize(opts)
      super
      @opts = opts
    end

    def client(opts = nil)
      (Thread.current[:fastly_client] ||= {})[self.__id__] ||= Fastly::Client.new(opts || @opts)
    end
  end
end

Fastly.__send__(:prepend, Codily::FastlyExt)
