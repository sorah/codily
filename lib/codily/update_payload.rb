module Codily
  class UpdatePayload
    def initialize(id: nil, service_id: nil, version_number: nil, name: nil, hash: nil)
      @id = id
      @service_id = service_id
      @version_number = version_number
      @name = name
      @hash = hash
    end

    attr_accessor :id, :service_id, :version_number, :name, :hash

    def as_hash
      @hash
    end
  end
end
