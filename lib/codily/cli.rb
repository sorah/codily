require 'optparse'

require 'codily/root'
require 'codily/importer'
require 'codily/dumper'
require 'codily/engine'

require 'fastly'

module Codily
  class Cli
    def initialize(argv)
      @argv = argv.dup
    end

    def run
      optparse.parse!(@argv)
      case options[:mode]
      when :version
        do_version
      when :apply
        do_apply
      when :export
        do_export
      else
        $stderr.puts "ERROR: you should choose operation from --apply (-a), or --export (-e)"
        $stderr.puts
        $stderr.puts optparse.help
        16
      end
    end

    def do_version
      puts "Codily #{Codily::VERSION}"
      0
    end

    def do_apply
      options[:file] ||= './codily.rb'
      Dir.chdir(File.dirname(options[:file]))

      present = importer.run.root
      desired = Root.new(debug: options[:debug]).run_string(File.read(File.basename(options[:file])), options[:file], 1)

      require_fastly_auth!

      engine = Engine.new(fastly, present, desired, service_filter: options[:target])

      act = engine.run(dry_run: options[:dry_run])

      0
    end

    def do_export
      if options[:file] && File.exist?(options[:file])
        raise "File #{options[:file].inspect} already exists!"
      end

      require_fastly_auth!

      importer.run

      rb = Dumper.new(importer.root).ruby_code

      if options[:file]
        File.write options[:file], rb
      else
        puts rb
      end

      0
    end

    def importer
      @importer ||= Importer.new(fastly, service_filter: @options[:target], import_targets: @options[:export_versions], debug: @options[:debug])
    end

    def options
      @options ||= {
        file: nil,
        export_versions: {},
        debug: false,
        dry_run: false,
        apply: false,
        activate: false,
      }
    end

    def optparse
      @optparse ||= OptionParser.new do |opt|
        opt.on('-a', '--apply') { options[:mode] = :apply }
        opt.on('-e', '--export') { options[:mode] = :export }
        opt.on('-v', '--version') { options[:mode] = :version }

        opt.on('-f PATH', '--file PATH', 'file to apply, or file path to save exported file (default to ./codily.rb on applying)') do |file|
          options[:file] = file
        end

        opt.on('-t REGEXP', '--target REGEXP', 'Filter services by name to apply or export.') do |regexp|
          options[:target] = [Regexp.new(regexp)]
        end

        opt.on('-n', '--dry-run', "Just displays the oprerations that would be performed, without actually running them.") do
          options[:dry_run] = true
        end

        opt.on('-D', '--debug', "Debug mode") do
          options[:debug] = true
        end

        #opt.on('-A', '--activate', "Activate after apply") do
        #  options[:activate] = true
        #end

        #opt.on('-d', '--diff', "Call diff API after apply") do
        #  options[:diff] = true
        #end

        opt.on('-V SVC_VER', '--target-version SVC_VER', "Choose version to export (format= service_name:version) This option can be used multiple time.") do |svcvers|
          svcver = svcvers.split(?:)
          ver = svcver.pop
          svc = svcver.join(?:)
          options[:export_versions][svc] = ver.to_i
        end
      end
    end

    def fastly
      @fastly ||= begin
        Fastly.new(api_key: ENV['FASTLY_API_KEY'])
      end
    end

    private

    def require_fastly_auth!
      unless fastly.authed?
        raise "Cannot authenticate with Fastly. Make sure to have environment variable FASTLY_API_KEY!"
      end
    end
  end
end
