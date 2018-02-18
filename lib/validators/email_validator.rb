module Validators
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A\S+@\S+\.\S+\z/i
        record.errors[attribute] << (options[:message] || "please enter a valid email address")
      end
    end
  end
end
