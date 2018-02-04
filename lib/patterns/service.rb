module Patterns
  module Service
    extend ActiveSupport::Concern

    attr_reader :result, :success, :error
    alias_method :success?, :success

    class_methods do
      def call(*args)
        # execute call and return service obj instance
        # return value of call method is accessible through result method
        new(*args).tap do |service|
          service.instance_eval do
            @result = service.call
            @success = !!@result unless @success == false
          end
        end
      end
    end


    def call
      raise NoMethodError, "define #call method in class: #{self.class.name}"
    end

    def fail(*args)
      @success = false
      @error = args.first
      super # call ruby's fail method and pass *args
    end

    # error state without raising exception
    def err(msg = nil)
      @success = false
      @error = msg
    end
  end
end
