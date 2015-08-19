class SandboxableModel < ActiveRecord::Base
  include Sandboxable::ActiveRecord
end