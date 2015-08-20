module Sandboxable
  module ActiveRecord
    extend ::ActiveSupport::Concern

    included do
      default_scope ->{
        unless Sandboxable::ActiveRecord.current_sandbox_id == ANY_SANDBOX
          return @sandbox_proc || self.default_proc
        end
        -> {}
      }
      before_save :set_sandbox_field
    end

    def as_json(options={})
      except = Array(options.delete(:except)) + [self.class.sandbox_field]

      super(options.merge(except: except))
    end

    def set_sandbox_field
      self.send("#{self.class.sandbox_field}=", Sandboxable::ActiveRecord.current_sandbox_id)
    end

    private :set_sandbox_field

    class << self
      def current_sandbox_id(new_value = nil)
        @sandbox_id = new_value || @sandbox_id
      end
    end

    module ClassMethods
      # Allow you to set a differend sanbox_id field.
      # If you pass a block it will be used as default scope instead of the default_proc
      #
      # ==== Examples
      #   # Use :test_id as sandbox_id field
      #   sandbox_with :test_id
      #   # Use a custom proc as default scope
      #   sandbox_with do
      #     where(:test_id => self.current_sandbox_id)
      #   end
      def sandbox_with(field = nil, &block)
        return @sandbox_proc = block if block
        @sandbox_field = field
      end

      def default_proc
        -> { where(self.sandbox_field => Sandboxable::ActiveRecord.current_sandbox_id) }
      end

      def sandbox_field
        @sandbox_field || :sandbox_id
      end
    end
  end
end
