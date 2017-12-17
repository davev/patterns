# Patterns

A collection of reusable Ruby objects for Rails applications.
* Service object module (to be used as a mixin)
* ApiRequest class (matches interface of Unirest)
* Notifier class (for reporting to bug tracking services, matches interface of Rollbar)

## Inspiration

* https://github.com/Selleo/pattern
* https://github.com/Selleo/business_process
* http://multithreaded.stitchfix.com/blog/2015/06/02/anatomy-of-service-objects-in-rails/
* https://medium.com/selleo/essential-rubyonrails-patterns-part-1-service-objects-1af9f9573ca1
* http://unirest.io/ruby.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fifteenthirty-patterns'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fifteenthirty-patterns

## Usage

TODO:

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/patterns. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Patterns project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/patterns/blob/master/CODE_OF_CONDUCT.md).
