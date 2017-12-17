require "test_helper"

class NotifierTest < ActiveSupport::TestCase

  test "instance methods are forwarded to class" do
    method_name = :foobar
    Patterns::Notifier.expects(method_name)
    Patterns::Notifier.new.send(method_name)
  end

  test "delegates to Rollbar" do
    # class
    Rollbar.expects(:error)
    Patterns::Notifier.error

    # instance
    Rollbar.expects(:info)
    Patterns::Notifier.new.info
  end

end
