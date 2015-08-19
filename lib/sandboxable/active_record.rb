module Sandboxable
  module ActiveRecord
    extend ::ActiveSupport::Concern

    included do
      default_scope { where(sandbox_id: self.sandbox_id) }

      before_save :set_sandbox_id
    end

    def as_json(options={})
      except = Array(options.delete(:except)) + [:sandbox_id]

      super(options.merge(except: except))
    end

    private
    def set_sandbox_id
      self.sandbox_id ||= self.sandbox_id
    end

    module ClassMethods
      def sandbox_id(new_value = nil)
        @sandbox_id ||= new_value
      end
    end
  end
end
