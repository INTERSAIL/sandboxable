require 'spec_helper'

module Sandboxable
  describe ActiveRecord do
    before do
      @s1 = SandboxableModel.create(name: "model_a", another_sandbox_id: 2)
      @s1.update_column(:sandbox_id, 1)
      @s2 = SandboxableModel.create(name: "model_b", another_sandbox_id: 1)
      @s2.update_column(:sandbox_id, 2)
    end

    describe '#as_json' do
      it 'serializes the object except he sandbox_id field' do
        expect(@s1.as_json).to eq({"id"=>1, "name"=>"model_a", "another_sandbox_id"=>2})
      end
    end

    describe '#default_scope' do
      before { Sandboxable::ActiveRecord.current_sandbox_id 1 }
      describe '#callbacks' do
        before {Sandboxable::ActiveRecord.current_sandbox_id 3}
        it 'set sandbox_field value to the current_sandbox_id before_save' do
          @s3 = SandboxableModel.create(name: "model_c", sandbox_id: 0)
          expect(@s3.sandbox_id).to eq(3)
        end
      end
      describe 'jolly values' do
        before { Sandboxable::ActiveRecord.current_sandbox_id -1 }
        it 'ignore default scopa if current_sandbox_id=-1' do
          expect(SandboxableModel.count).to eq(2)
        end
      end
      context 'sandbox_with not given' do
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