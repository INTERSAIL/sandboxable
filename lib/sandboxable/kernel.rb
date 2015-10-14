module Kernel
  delegate :current_sandbox_id, :current_sandbox_id=, to: Sandboxable::ActiveRecord
end