require "test_helper"

class ServiceTest < ActiveSupport::TestCase

  class DoFoo
    include ::Patterns::Service

    def initialize(msg)
      @msg = msg
    end

    def call
      return @msg
    end
  end

  setup do
    @foo = DoFoo.call('hi')
  end

  test "#call method is required to be defined" do
    do_bar = Class.new do
      include ::Patterns::Service
    end
    assert_raises(NoMethodError) { do_bar.call }
  end

  test "arguments are passed to constructor" do
    assert_raises(ArgumentError) { DoFoo.call }
    assert_silent { DoFoo.call('hi') }
  end

  test "#call method returns service object instance" do
    assert_kind_of DoFoo, @foo
  end

  test "invokes #call method on service object instance" do
    DoFoo.any_instance.expects(:call)
    DoFoo.call('ok')
  end

  test "result of #call method is accessible through #result method" do
    assert_equal @foo.result, "hi"
  end

  test "responds to success? with true for successful call" do
    assert @foo.success?
  end

  test "#err method does not raise exception" do
    assert_silent { @foo.err('oops') }
    refute @foo.success?
    assert_equal @foo.error, 'oops'
  end

  test "#fail method raises exception" do
    assert_raises(RuntimeError) { @foo.fail('oops') }
    refute @foo.success?
    assert_equal @foo.error, 'oops'
  end
end
