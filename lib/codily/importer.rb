require 'fastly'
require 'codily/fastly_ext'

require 'codily/root'

require 'codily/elements/service'

require 'codily/elements/backend'
require 'codily/elements/cache_setting'
require 'codily/elements/condition'
require 'codily/elements/dictionary'
require 'codily/elements/domain'
require 'codily/elements/gzip'
require 'codily/elements/header'
require 'codily/elements/healthcheck'
require 'codily/elements/request_setting'
require 'codily/elements/response_object'
require 'codily/elements/vcl'
require 'codily/elements/settings'

module Codily
  class Importer
    def initialize(fastly, export_targets: {})
      @fastly = fastly
      @export_targets = export_targets

      @ran = false
      @root = Codily::Root.new(debug: true)
    end

    attr_reader :fastly, :root

    def run
      return self if @ran

      fastly.list_services.each do |service|
        service_version = root.service_version_set(service.name, service.id, service.versions)
        export_version = @export_targets[service.id] || @export_targets[service.name] || service_version[:dev]

        root.add_element Elements::Service.new(root, service)

        threads = {
          Elements::Backend => proc { fastly.list_backends(service_id: service.id, version: export_version) },
          Elements::CacheSetting => proc { fastly.list_cache_settings(service_id: service.id, version: export_version) },
          Elements::Condition => proc { fastly.list_conditions(service_id: service.id, version: export_version) },
          Elements::Dictionary => proc { fastly.list_dictionaries(service_id: service.id, version: export_version) },
          Elements::Domain => proc { fastly.list_domains(service_id: service.id, version: export_version) },
          Elements::Gzip => proc { fastly.list_gzips(service_id: service.id, version: export_version) },
          Elements::Header => proc { fastly.list_headers(service_id: service.id, version: export_version) },
          Elements::Healthcheck => proc { fastly.list_healthchecks(service_id: service.id, version: export_version) },
          Elements::RequestSetting => proc { fastly.list_request_settings(service_id: service.id, version: export_version) },
          Elements::ResponseObject => proc { fastly.list_response_objects(service_id: service.id, version: export_version) },
          Elements::Vcl => proc { fastly.list_vcls(service_id: service.id, version: export_version) },
        }.map do |k, list_proc|
          Thread.new(k) do |klass|
            list_proc.call.map do |_|
              klass.new(root, _)
            end
          end
        end

        threads.each(&:value)
        threads.flat_map(&:value).each do |elem|
          root.add_element elem
        end
      end

      @ran = true
      self
    end
  end
end
