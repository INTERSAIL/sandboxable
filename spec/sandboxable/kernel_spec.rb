require 'spec_helper'

describe Kernel do
  describe '#current_sandbox_id' do
    it 'delegates methdot do Sandboxable::ActiveRecord' do
      val = 1
      expect(Sandboxable::ActiveRecord).to receive(:current_sandbox_id).with(val)
      current_sandbox_id val
    end
  end
end