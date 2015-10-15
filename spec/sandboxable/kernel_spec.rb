require 'spec_helper'

describe Kernel do
  let(:val) { 1 }
  describe '#current_sandbox_id' do
    it 'delegates current_sandbox_id method do Sandboxable::ActiveRecord' do
      expect(Sandboxable::ActiveRecord).to receive(:current_sandbox_id).with(val)
      current_sandbox_id val
    end
  end
end