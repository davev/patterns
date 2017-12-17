require 'rollbar'
require 'active_support/core_ext/module/delegation'

module Patterns
  # delegate everything to Rollbar
  # if we switch providers, can keep the same API but implement
  # Notifier.error, Notifier.warning, Notifier.info, etc. here
  # see https://github.com/rollbar/rollbar-gem for Rollbar API reference
  # * requires Rollbar credentials to be set

  class Notifier
    class << self
      delegate *Rollbar::PUBLIC_NOTIFIER_METHODS, to: Rollbar
    end
  end
end
