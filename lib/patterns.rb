require 'active_support/concern'

require "patterns/version"
require "patterns/service"
require "patterns/api_request"
require "patterns/notifier"

module Patterns
end

ActiveRecord::Base.send(:include, Validators)
