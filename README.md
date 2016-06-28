# Codily: Codificate your Fastly configuration

__still not working, this is in active development phase__

## Installation

```ruby
# Gemfile
gem 'codily'
```

Or install it yourself as:

    $ gem install codily

## Usage

planning

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
    ipv4
    ipv6
    locked
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

  director "name" do
    type
    retries
    quorum
    comment

    backend "name"
    backend "name"
    backend "name"
  end

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
    "general.default_ttl" => 3600,
  )
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/codily.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

