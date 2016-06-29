module Codily
  module Utils
    def self.symbolize_keys(obj)
      case obj
      when Hash
        Hash[
          obj.map do |k, v|
            [k.to_sym, symbolize_keys(v)]
          end
        ]
      when Array
        obj.map { |_| symbolize_keys(_) }
      else
        obj
      end
    end
  end
end
