require 'spec_helper'

describe Kernel do
  let(:val) { 1 }
  describe '#current_sandbox_id' do
    it 'delegates current_sandbox_id method do Sandboxable::ActiveRecord' do
      expect(Sandboxable::ActiveRecord).to receive(:current_sandbox_id).with(val)
      current_sandbox_id val
    end
  end
  describe '#current_sandbox_id=' do
    let(:new_val) { 2 }
    it 'delegates current_sandbox_id= method do Sandboxable::ActiveRecord' do
      current_sandbox_id=new_val
      expect(current_sandbox_id).to eq(new_val)
    end
  end
end