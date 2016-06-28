require 'codily/elements/service_belongging_base'
require 'codily/elements/file_loadable'

module Codily
  module Elements
    class Vcl < ServiceBelonggingBase
      include FileLoadable

      def content(obj)
        getset :content, file_loadable(obj)
      end

      def main(bool = nil)
        getset :main, bool
      end

      def fastly_class
        Fastly::VCL
      end
    end
  end
end
