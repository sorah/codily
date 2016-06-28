module Codily
  module Elements
    module FileLoadable
      def self.included(klass)
        klass.instance_eval do
          def def_file_loadable_attr(*attrs)
            attrs.each do |attr|
              define_method(attr) do |obj = nil|
                getset attr, file_loadable(obj)
              end
            end
          end
        end
      end

      private

      def file_loadable(obj)
        case obj
        when String
          return obj
        when Hash
          if obj.key?(:inline)
            return obj[:inline]
          end
          if obj.key?(:file)
            return File.read(obj[:file])
          end
          raise ArgumentError
        end
      end
    end
  end
end
