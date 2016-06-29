require 'codily/elements/service_belongging_base'
require 'codily/elements/backend'
require 'codily/elements/director_backend'

module Codily
  module Elements
    class Director < ServiceBelonggingBase
      def_attr *%i(
        type
        retries
        quorum
        comment
      )

      defaults(
        retries: 5,
        capacity: 100,
        type: 1,
        quorum: 75,
      )

      def setup
        delete_if_empty! :comment
      end

      def backend(name, &block)
        backend = refer_element(Backend, {name: name, _service_name: self.service_name}, :name, &block)
        root.add_element DirectorBackend.new(root, director_name: name, backend_name: backend.name, _service_name: self.service_name)
      end

      def fastly_class
        Fastly::Director
      end
    end
  end
end
