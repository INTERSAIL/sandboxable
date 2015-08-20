module Sandboxable
  module ActiveRecord
    extend ::ActiveSupport::Concern

    included do
      default_scope -> {
        unless Sandboxable::ActiveRecord.current_sandbox_id == ANY_SANDBOX
          return @sandbox_proc || Sandboxable::ActiveRecord.default_proc
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
      send("#{self.class.sandbox_field}=", Sandboxable::ActiveRecord.current_sandbox_id) if self.class.persist
    end

    private :set_sandbox_field

    class << self
      def current_sandbox_id(new_value = nil)
        @current_sandbox_id = new_value || @current_sandbox_id
      end

      def default_proc
        -> { where(self.sandbox_field => Sandboxable::ActiveRecord.current_sandbox_id) }
      end
    end

    module ClassMethods
      # Allow you to use sanbox_id field.
      # ==== Options
      #   - field: the sandbox_id field column name. default: :sandbox_id
      #   - persist: when true sets the sandbox_id field in the before_save callback to the
      #              Sandboxable::ActiveRecord.current_sandbox_id value. default: true
      #
      # NOTE: You can pass a block it will be used as default scope instead of the default_proc
      #
      # ==== Examples
      #   # Use :test_id as sandbox_id field and persist it
      #   sandbox_with field: :test_id
      #   # Use a custom proc as default scope and does not persist the sandbox_id field
      #   sandbox_with persist:false do
      #     where(:test_id => self.current_sandbox_id)
      #   end
      def sandbox_with(options = {}, &block)
        options.reverse_merge! field: :sandbox_id, persist: true
        @sandbox_field = options[:field]
        @persist = options[:persist]
        @sandbox_proc = block if block
      end

      def sandbox_field
        @sandbox_field || :sandbox_id
      end

      def persist
        @persist.nil? ? true : @persist
      end
    end
  end
end
