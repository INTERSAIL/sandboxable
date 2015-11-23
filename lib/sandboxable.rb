require 'sandboxable/version'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'sandboxable/active_record'
require 'sandboxable/active_record/multiple_sandbox_strategy'
require 'sandboxable/kernel'
require 'request_store'

module Sandboxable
  ANY_SANDBOX = 'any'
end
