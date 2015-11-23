module Sandboxable
  module ActiveRecord
    class MultipleSandboxStrategy
      class << self
        def default_proc
          ->{ where(self.sandbox_field => Sandboxable::ActiveRecord.current_sandbox_id.to_s.split(",").map(&:to_i)) }
        end

        def default_set_proc
          ->{Sandboxable::ActiveRecord.current_sandbox_id.to_s.split(",").first.to_i}
        end
      end
    end
  end
end