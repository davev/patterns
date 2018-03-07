$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'patterns'

require 'minitest/autorun'
require 'minitest/reporters'

require 'mocha/mini_test'
require 'webmock/minitest'

require 'active_support'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
