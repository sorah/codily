require 'spec_helper'

require 'codily/root'

# Actually testing DSL
describe Codily::Root do
  describe "(scinario: runs successfully)" do
    subject { described_class.new.run_string(<<-'EOS', "(eval:#{__FILE__})", __LINE__.succ) }
service "test.example.com" do
  backend "backend-a" do
    address "backend.example.com"
    auto_loadbalance false
    between_bytes_timeout 100
    client_cert "TEST"
    comment "comment"
    connect_timeout 101
    error_threshold 102
    first_byte_timeout 103
    healthcheck "healthcheck-a"
    hostname "backend.example.com"
    ipv4 "127.0.0.1"
    ipv6 "::1"
    max_conn 104
    max_tls_version "TLS1.0"
    min_tls_version "TLS1.2"
    port 443
    request_condition "condition-1"
    shield "IAD"
    ssl_ca_cert "TEST2"
    ssl_cert_hostname "test.example.com"
    ssl_check_cert true
    ssl_ciphers "TEST3"
    ssl_client_cert "TEST4"
    ssl_client_key "TEST5"
    ssl_hostname "test.example.com"
    ssl_sni_hostname "test.example.com"
    use_ssl true
    weight 105
  end

  cache_setting "cache-setting-a" do
    action :pass
    stale_ttl 60
    ttl 120

    cache_condition "name"
  end

  condition "condition-2" do
    comment "comment"
    priority 100
    statement "beresp.status == 200"
  end

  dictionary "name"

  domain "a.example.org"
  domain "b.example.org" do
    comment "comment"
  end

  gzip "gzip-a" do
    content_types %w(text/html)
    extensions %w(html)
    cache_condition "condition-3"
  end

  header 'header-a' do
    action :set
    src 'beresp.status'
    dst 'resp.X-Test'
    ignore_if_set true
    priority 100
    substitution 'test'
    type :request
    cache_condition "condition-4"
    request_condition "condition-5"
    response_condition "condition-6"
  end

  healthcheck 'healthcheck-b' do
    check_interval 60
    comment "comment"
    expected_response 200
    host "test.example.com"
    http_version "1.1"
    initial 2
    method "GET"
    path "/health"
    threshold 3
    timeout 500
    window 5
  end

  request_setting "request-setting-a" do
    action :lookup
    bypass_busy_wait false
    default_host "test.example.com"
    force_miss true
    force_ssl true
    geo_headers true
    hash_keys "null"
    max_stale_age 60
    timer_support true
    xff :append
    request_condition "condition-7"
  end

  response_object "name" do
    content "test\n"
    content_type "text/plain"
    status 200
    response "Ok"
    cache_condition "condition-8"
    request_condition "condition-9"
  end

  vcl "name" do
    content "test"
    main true
  end

  settings(
    "general.default_ttl" => 3600,
  )
end
    EOS

    specify do
      expect { subject }.not_to raise_error
    end
  end

  describe "(scinario: referring element)" do
    subject { described_class.new.run_string(<<-'EOS', "(eval:#{__FILE__})", __LINE__.succ) }
service "test" do
  condition "condition-a" do
    statement "beresp.status == 200"
  end

  cache_setting "cache-setting-a" do
    cache_condition "condition-a"
  end

  cache_setting "cache-setting-b" do
    cache_condition "condition-b" do
      statement "beresp.status == 201"
    end
  end
end
    EOS

    specify do
      expect(subject.list_element(Codily::Elements::CacheSetting).size).to eq 2
      expect(subject.list_element(Codily::Elements::Condition).size).to eq 2

      expect(subject.list_element(Codily::Elements::CacheSetting)[%w(test cache-setting-a)].cache_condition).to eq 'condition-a'
      expect(subject.list_element(Codily::Elements::Condition)[%w(test condition-a)].statement).to eq 'beresp.status == 200'

      expect(subject.list_element(Codily::Elements::CacheSetting)[%w(test cache-setting-b)].cache_condition).to eq 'condition-b'
      expect(subject.list_element(Codily::Elements::Condition)[%w(test condition-b)].statement).to eq 'beresp.status == 201'
    end
  end
end
