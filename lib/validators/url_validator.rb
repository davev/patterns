module Validators
  class UrlValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\Ahttps?:\/\/[a-z0-9-]+\.\S+\z/i
        record.errors[attribute] << (options[:message] || "please enter a valid url, for example: http://www.your-domain.com")
      end
    end
  end
end
