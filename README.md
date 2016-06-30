# Codily: Codificate your Fastly configuration

__still in beta__

Codily allows you to manage your Fastly configuration in Ruby DSL!

## Installation

```ruby
# Gemfile
gem 'codily'
```

Or install it yourself as:

    $ gem install codily --pre

## Usage


```
Usage: codily [options]
    -a, --apply
    -e, --export
    -v, --version
    -f, --file PATH                  file to apply, or file path to save exported file (default to ./codily.rb on applying)
    -t, --target REGEXP              Filter services by name to apply or export.
    -n, --dry-run                    Just displays the oprerations that would be performed, without actually running them.
    -D, --debug                      Debug mode
    -V, --target-version SVC_VER     Choose version to export (format= service_name:version) This option can be used multiple time.
```

```
codily --help

codily --export
codily --export --target my-service
codily --export --target my-service --target-version my-service:42
codily --export --file ./codily.rb

codily --apply --file ./codily.rb
codily --apply --file ./codily.rb --dry-run
codily --apply --file ./codily.rb --target my-service
```

You have to set api key in environment variable `FASTLY_API_KEY`

## Restrictions

- Directors are not supported due to its deprecation

## DSL

### tl;dr

It's easy to start by export existing configuration into DSL using `--export` option.

``` ruby
service "foo" do
  backend "my backend" do
    address "example.com"
  end
end
```

### Loading file

some attributes (e.g. tls certificates, tls keys, VCL content, response object content) supports loading value from a file.

``` ruby
service "foo" do
  vcl "default" do
    main true
    content file: './my.vcl'
  end
end
```

### Referring other object (e.g. condition)

Some attributes that refers other object (e.g. conditions), you can define referring object as like the following:

``` ruby
service "foo" do
  response_object "method not allowed" do
    status "405"
    response "Method Not Allowed"
    content "405"
    content_type "text/plain"

    request_condition "request method is not GET, HEAD or FASTLYPURGE" do
      priority 10
      statement '!(req.request == "GET" || req.request == "HEAD" || req.request == "FASTLYPURGE")'
    end
  end
end

# equals as follows:

service "foo" do
  condition "request method is not GET, HEAD or FASTLYPURGE" do
    priority 10
    statement '!(req.request == "GET" || req.request == "HEAD" || req.request == "FASTLYPURGE")'
    type "REQUEST"
  end

  response_object "method not allowed" do
    status "405"
    response "Method Not Allowed"
    content "405"
    content_type "text/plain"
    request_condition "request method is not GET, HEAD or FASTLYPURGE"
  end
end
```

### Full example

Basically, all attributes are 

``` ruby
service "test.example.com" do
  backend "name" do
    address
    auto_loadbalance
    between_bytes_timeout
    client_cert
    comment
    connect_timeout
    error_threshold
    first_byte_timeout
    healthcheck
    hostname
    max_conn
    max_tls_version
    min_tls_version
    port
    request_condition
    service_id
    shield
    ssl_ca_cert
    ssl_cert_hostname
    ssl_check_cert
    ssl_ciphers
    ssl_client_cert
    ssl_client_key
    ssl_hostname
    ssl_sni_hostname
    use_ssl
    weight
  end

  cache_setting "name" do
    action
    stale_ttl
    ttl

    cache_condition "name"
    # cache_condition do
    #   comment
    #   priority
    #   statement
    # end
  end

  condition "name" do
    comment
    priority
    statement
  end

  dictionary "name"

  domain "a.example.org"
  domain "a.example.org" do
    comment ""
  end

  gzip "name" do
    content_types %w(text/html)
    extensions %w(html)
    cache_condition "name"
    # cache_condition do
    #   comment
    #   priority
    #   statement
    # end
  end

  header 'name' do
    action
    src
    dst
    ignore_if_set
    priority
    substitution
    type
    cache_condition
    request_condition
    response_condition
  end

  healthcheck 'name' do
    check_interval
    comment
    expected_response
    host
    http_version
    initial
    method
    path
    threshold
    timeout
    window
  end

  request_setting "name" do
    action
    bypass_busy_wait
    default_host
    force_miss
    force_ssl
    geo_headers
    hash_keys
    max_stale_age
    timer_support
    xff
    request_condition
  end

  response_object "name" do
    content
    content_type
    status
    response
    cache_condtiion
    request_condition
  end

  vcl "name" do
    content file: 'xxx'
    main true
  end

  settings(
    "general.default_ttl": 3600,
  )
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sorah/codily.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

