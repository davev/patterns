require 'unirest'
require 'active_support/core_ext/hash'

module Patterns

  # same signature (matches Unirest) for calling any ApiRequest.[verb](endpoint_uri, headers:, params:)
  # examples:
  #   ApiRequest.get("http://www.foo.com/users, headers:{ "Authorization" => 'abcdef' }, params: { user_id: 101} )
  #   you can pass in the token as a named arg w/o having to format it in the headers hash:
  #   ApiRequest.get("http://www.foo.com/users, token: "abcdef" )
  #
  # other options passed through named args:
  # quiet: true # fail silently, swallow exceptions (but notify Rollbar)
  # timeout: 120 # set timeout val (seconds) for this request
  # notifier: optional dependecy-injected object for error/exception notifications - object should conform to Rollbar api

  class ApiRequest
    attr_reader :code, :headers, :body, :raw_body, :error

    TIMEOUT_SECONDS = 60
    ALLOWED_METHODS = [:get, :post, :put, :patch, :delete].freeze
    DEFAULT_REQUEST_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }

    class << self
      def http_request(method,
                      endpoint_uri,
                      headers: {},
                      params: nil,
                      token: nil,
                      quiet: nil,
                      timeout: nil,
                      notifier: nil)

        request_headers = DEFAULT_REQUEST_HEADERS.merge(headers)
        request_headers.reverse_merge!("Authorization" => token) if token.present?

        new(quiet: quiet, timeout: timeout, notifier: notifier).tap do |req|
          req.http_request(method, endpoint_uri, request_headers, params)
        end
      end

      def method_missing(method, *args, &block)
        return http_request(method, *args, &block) if ALLOWED_METHODS.include?(method)
        super
      end
    end


    def initialize(opts = {})
      @opts = opts
      Unirest.timeout(opts[:timeout] || TIMEOUT_SECONDS)
    end

    def http_request(method, endpoint_uri, headers, parameters)
      response = Unirest.send(
        method.to_sym,
        endpoint_uri,
        headers: headers,
        parameters: parameters
      )

      if response
        @code = response.code
        @headers = response.headers
        @body = response.body
        @raw_body = response.raw_body
      end

      handle_failure unless success?


    rescue => e
      @error = e.message
      notify_exception(e)
      raise e unless @opts[:quiet]
    end

    def success?
      [200, 201].include?(code)
    end


    private

    def handle_failure
      @error = body || "[blank]"
      notify_error
      raise_error unless @opts[:quiet]
    end

    def notify_exception(e)
      notifier.error("ApiRequest Exception", e)
    end

    def notify_error
      notifier.error("ApiRequest Error", response_code: code, response_body: body, error: error)
    end

    def raise_error
      raise "ApiRequest Error #{code}: #{error}"
    end

    def notifier
      @opts[:notifier] || Notifier.new
    end
  end

end
