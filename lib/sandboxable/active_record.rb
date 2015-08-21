module Sandboxable
  module ActiveRecord
    extend ::ActiveSupport::Concern

    ::ActiveRecord::Scoping.class_eval do
      def populate_with_current_scope_attributes
        # == MonkeyPatch
        # Does not populate_with_current_scope attributes anymore. This is needed
        # in order to solve a problem where the sandbox_field value is initialized
        # always with the default_scope value, that will lead into problems for the
        # creation of a record
        # == Original code
        # return unless self.class.scope_attributes?
        #
        # self.class.scope_attributes.each do |att,value|
        #   send("#{att}=", value) if respond_to?("#{att}=")
        # end
      end
    end

    included do
      default_scope -> {
        unless Sandboxable::ActiveRecord.current_sandbox_id.to_i == ANY_SANDBOX
          return @sandbox_proc || Sandboxable::ActiveRecord.default_proc
        end
        -> {}
      }
      before_save :set_sandbox_field
    end

    def as_json(options={})
      except = Array(options.delete(:except)) + [self.class.sandbox_field] unless self.class.serialize_sandbox_field

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
      #   - serialize_sandbox_field: when false the sandbox_field will not be serialized default: false
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
        options.reverse_merge! field: :sandbox_id, persist: true, serialize_sandbox_field: false
        @sandbox_field = options[:field]
        @persist = options[:persist]
        @serialize_sandbox_field = options[:serialize_sandbox_field]
        @sandbox_proc = block if block
      end

      def sandbox_field
        @sandbox_field || :sandbox_id
      end

      def persist
        @persist.nil? ? true : @persist
      end

      def serialize_sandbox_field
        @serialize_sandbox_field.nil? ? false : @serialize_sandbox_field
      end
    end
  end
end
