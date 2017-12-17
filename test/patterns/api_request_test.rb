require "test_helper"

class ApiRequestTest < ActiveSupport::TestCase

  setup do
    @endpoint = "http://url.com"
    @headers = { a: 1, b: 2}
    @params = { "foo" => "bar" }

    stub_request(:any, @endpoint)
  end

  test "responds to supported verb class methods" do
    assert_silent do
      Patterns::ApiRequest::ALLOWED_METHODS.each do |verb|
        Patterns::ApiRequest.send(verb, @endpoint)
      end
    end
  end

  test "all verbs have the same api through method_missing" do
    Patterns::ApiRequest::ALLOWED_METHODS.each do |verb|
      Patterns::ApiRequest.expects(:http_request).with(verb, @endpoint, headers: @headers, params: @params)
    end

    Patterns::ApiRequest::ALLOWED_METHODS.each do |verb|
      Patterns::ApiRequest.send(verb, @endpoint, headers: @headers, params: @params)
    end
  end

  test "#get method invokes #http_request method on instance with appropriate args" do
    hdrs = Patterns::ApiRequest::DEFAULT_REQUEST_HEADERS.merge(@headers)

    Patterns::ApiRequest.any_instance.expects(:http_request).with(:get, @endpoint, hdrs, @params)
    Patterns::ApiRequest.get(@endpoint, headers: @headers, params: @params)
  end

  test "#get method returns service object instance" do
    response = Patterns::ApiRequest.get(@endpoint)
    assert_kind_of Patterns::ApiRequest, response
  end

  test "returned response responds to expected methods" do
    response = Patterns::ApiRequest.get(@endpoint)

    assert_respond_to response, :code
    assert_respond_to response, :headers
    assert_respond_to response, :body
    assert_respond_to response, :raw_body
    assert_respond_to response, :success?
    assert_respond_to response, :error

    refute_respond_to response, :bogus_method
  end

  test "responds to successful request" do
    response = Patterns::ApiRequest.get(@endpoint)
    assert_equal response.code, 200
    assert response.success?
  end

  test "responds to unsuccessful request" do
    Unirest.expects(:get) # will return nil
    response = Patterns::ApiRequest.get(@endpoint, quiet: true)
    assert_not_equal 200, response.code
    refute response.success?
    assert_respond_to response, :error
    assert response.error.present?
  end

  test "delegates to Unirest" do
    Unirest.expects(:get)
    Patterns::ApiRequest.get(@endpoint, quiet: true)
  end

  test "token option is merged into headers hash under Authorization key" do
    tok = 'abc123'
    hdrs = Patterns::ApiRequest::DEFAULT_REQUEST_HEADERS.
           merge(@headers).
           reverse_merge("Authorization" => tok)

    Patterns::ApiRequest.any_instance.expects(:http_request).with(:get, @endpoint, hdrs, @params)
    Patterns::ApiRequest.get(@endpoint, headers: @headers, params: @params, token: tok)
  end

  test "quiet option silences exceptions" do
    Unirest.stubs(:get) # will return nil, which will raise exception by default
    assert_raises { Patterns::ApiRequest.get(@endpoint) }
    assert_silent { Patterns::ApiRequest.get(@endpoint, quiet: true) }
  end

  test "timeout option passes value to Unirest" do
    secs = 99
    Unirest.expects(:timeout).with(secs)
    Patterns::ApiRequest.get(@endpoint, timeout: secs)
  end

end
