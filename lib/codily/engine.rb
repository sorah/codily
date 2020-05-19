require 'codily/update_payload'

require 'codily/elements/service'

require 'codily/elements/condition'
require 'codily/elements/backend'
require 'codily/elements/cache_setting'
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
  class Engine
    def initialize(fastly, present, desired, service_filter: nil, activate: false)
      @fastly = fastly
      @present = present
      @desired = desired

      @service_filter = service_filter
      @activate = activate
    end

    attr_reader :fastly, :present, :desired, :service_filter, :activate

    ORDER = [
      Elements::Service,
      Elements::Settings,
      Elements::Condition,
      Elements::Healthcheck,
      Elements::Backend,
      Elements::CacheSetting,
      Elements::Dictionary,
      Elements::Domain,
      Elements::Gzip,
      Elements::Header,
      Elements::RequestSetting,
      Elements::ResponseObject,
      Elements::Vcl,
    ]

    def run(dry_run: false)
      if dry_run
        puts "(dry-run)"
        puts
      end

      affected_services.each do |key|
        version = present.service_version_get(key)
        if !version[:dev]
          puts "CLONE VERSION: #{version[:name]}.#{version[:active]}"
          if !dry_run
            version[:dev] = fastly.get_version(version[:id], version[:active]).clone.number
          end
        end
      end

      puts

      creations.each do |new_element|
        puts "CREATE: #{new_element.inspect}"

        hash = new_element.as_hash

        if new_element.parent_class == Elements::Service
          service_version = present.service_version_get(new_element.service_name)
          hash[:service_id] = service_version[:id]
          hash[:version] = service_version[:dev]
        end

        unless dry_run
          new_obj = fastly.create(new_element.fastly_class, hash)

          if new_element.class == Elements::Service
            present.service_version_set(new_obj.name, new_obj.id, new_obj.versions)
          end
        end
      end

      updates.each do |present_elem, desired_elem|
        puts "UPDATE: - #{present_elem.inspect}"
        puts "        + #{desired_elem.inspect}"

        payload = UpdatePayload.new(name: present_elem.name, id: present_elem.id, hash: desired_elem.as_hash)
        if desired_elem.parent_class == Elements::Service
          service_version = present.service_version_get(desired_elem.service_name)
          payload.service_id = service_version[:id]
          payload.version_number = service_version[:dev]
        end

        unless dry_run
          fastly.update(desired_elem.fastly_class, payload)
        end
      end

      removals.each do |removed_element|
        puts "DELETE: #{removed_element.inspect}"

        unless dry_run
          removed_element.fastly_obj.delete!
        end
      end

      act_any = !affected_services.empty?

      unless act_any
        puts "No difference."
      end

      puts

      if activate
        affected_services.each do |id|
          version = present.service_version_get(id)
          puts "ACTIVATE VERSION: #{version[:name]}.#{version[:dev]}"
          if !dry_run
            fastly.get_version(version[:id], version[:dev]).activate!
          end
        end
      end

      act_any
    end

    def creations
      @creations ||= begin
        new_keys = desired_element_keys - present_element_keys
        sort_elements(new_keys.map{ |_| desired.elements[_[0]][_[1]] })
      end
    end

    def updates
      @updates ||= begin
        common = present_element_keys & desired_element_keys

        present_existing = common.map{ |_| present.elements[_[0]][_[1]] }
        desired_existing = common.map{ |_| desired.elements[_[0]][_[1]] }

        raise '!?' if present_existing.size != desired_existing.size

        present_existing.zip(desired_existing).map do |present_elem, desired_elem|
          if present_elem.as_hash != desired_elem.as_hash
            [present_elem, desired_elem]
          else
            nil
          end
        end.compact.sort_by { |_| ORDER.index(_[0].class) }
      end
    end

    def removals
      @removals ||= begin
        removed_keys = present_element_keys - desired_element_keys
        sort_elements(removed_keys.map{ |_| present.elements[_[0]][_[1]] })
      end
    end

    def affected_services
      [*creations, *removals, *updates.map(&:first)].
        select { |_| _.parent_class == Elements::Service }.
        map(&:parent_key).
        uniq
    end

    private

    def present_elements
      @present_elements ||= filter_elements(present.all_elements)
    end

    def desired_elements
      @desired_elements ||= filter_elements(desired.all_elements)
    end

    def present_element_keys
      @present_element_keys ||= present_elements.map { |_| [_.class, _.key] }
    end

    def desired_element_keys
      @desired_element_keys ||= desired_elements.map { |_| [_.class, _.key] }
    end

    def present_service_names
      @present_service_names ||= present.list_element(Elements::Service).each_value.map(&:name)
    end

    def filter_elements(elems)
      elems.select do |e|
        if e.parent_class == Elements::Service
          (@service_filter ? @service_filter.any? { |_| _ === e.service_name } : true) && present_service_names.include?(e.service_name)
        else
          true
        end
      end
    end

    def sort_elements(elems)
      elems.sort_by { |_| ORDER.index(_.class) }
    end
  end
end
