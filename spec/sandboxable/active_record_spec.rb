require 'spec_helper'

module Sandboxable
  describe ActiveRecord do

    before do
      @s1 = SandboxableModel.create(name: "model_a", sandbox_id: 1, another_sandbox_id: 2)
      @s2 = SandboxableModel.create(name: "model_b", sandbox_id: 2, another_sandbox_id: 1)
    end

    describe '#as_json' do
      it 'serializes the object except he sandbox_id field' do
        expect(@s1.as_json).to eq({"id"=>1, "name"=>"model_a", "another_sandbox_id"=>2})
      end
    end

    describe '#default_scope' do
      before { Sandboxable::ActiveRecord.current_sandbox_id 1 }
      context 'sanbox_with not given' do
        it 'apply a default scope using field sandbox_id' do
          expect(SandboxableModel.count).to eq(1)
          expect(SandboxableModel.first).to eq(@s1)
        end
      end
      context 'sandbox_with name given' do
        before do
          SandboxableModel.class_eval do
            sandbox_with :another_sandbox_id
          end
        end
        it 'apply a default scope with the name given' do
          expect(SandboxableModel.count).to eq(1)
          expect(SandboxableModel.first).to eq(@s2)
        end
      end
      context 'sandbox_with block given' do
        before do
          SandboxableModel.class_eval do
            sandbox_with do
              where(:sandbox_id => Sandboxable::ActiveRecord.current_sandbox_id)
            end
          end
        end
        it 'runs the given block as default scope with self' do
          expect(SandboxableModel.count).to eq(1)
          expect(SandboxableModel.first).to eq(@s1)
        end
      end
    end
  end
end