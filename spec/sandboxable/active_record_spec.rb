require 'spec_helper'

module Sandboxable
  describe ActiveRecord do

    before do
      @s1 = SandboxableModel.create(name: "model_a", sandbox_id: 1, another_sandbox_id: 2)
      @s2 = SandboxableModel.create(name: "model_b", sandbox_id: 2, another_sandbox_id: 1)
    end

    describe '#as_json' do

    end

    describe '#default_scope' do
      before { SandboxableModel.sandbox_id(1) }
      context 'sanbox_with not given' do
        it 'apply a default scope using field sandbox_id' do
          expect(SandboxableModel.count).to eq(1)
          expect(SandboxableModel.first).to eq(@s1)
        end
      end
      context 'sandbox_with name given' do
        xit 'apply a default scope with the name given'
      end
      context 'sandbox_with block given' do
        xit 'applya a default scupe that runs the given block'
      end
    end
  end
end