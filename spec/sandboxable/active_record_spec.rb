require 'spec_helper'

module Sandboxable
  describe ActiveRecord do
    before do
      Sandboxable::ActiveRecord.current_sandbox_id 1
      @s1 = SandboxableModel.create(name: "model_a", another_sandbox_id: 2)
      @s1.update_column(:sandbox_id, 1)
      @s2 = SandboxableModel.create(name: "model_b", another_sandbox_id: 1)
      @s2.update_column(:sandbox_id, 2)
    end

    describe '#as_json' do
      context 'serialize_sandbox_field=true' do
        before do
          SandboxableModel.class_eval do
            sandbox_with serialize_sandbox_field: false
          end
        end
        it 'serializes the object except he sandbox_id field' do
          expect(@s1.as_json).to eq({"id" => 1, "name" => "model_a", "another_sandbox_id" => 2})
        end
      end
      context 'serialize_sandbox_field=false' do
        before do
          SandboxableModel.class_eval do
            sandbox_with serialize_sandbox_field: true
          end
        end
        it 'serializes the object as whole' do
          expect(@s1.as_json).to eq({"id" => 1, "name" => "model_a", "sandbox_id" => 1, "another_sandbox_id" => 2})
        end
      end
    end

    describe '#before_save' do
      after { SandboxableModel.instance_variable_set("@sandbox_proc", nil) }
      context 'persist=true' do
        before do
          SandboxableModel.class_eval do
            sandbox_with persist: true
          end
        end
        it 'sets the sandbox_id field value to Sandboxable::ActiveRecord.current_sandbox_id' do
          expect(SandboxableModel.create(name: "persist=true").sandbox_id).to eq(1)
        end

      end
      context 'persist=false' do
        before do
          SandboxableModel.class_eval do
            sandbox_with persist: false
          end
        end
        it "doesn't set the sandbox_id field", focus: true do
          expect(SandboxableModel.create(name: "persist=false").sandbox_id).to be_nil
        end
      end
    end

    describe '#default_scope' do
      describe 'jolly values' do
        before { Sandboxable::ActiveRecord.current_sandbox_id Sandboxable::ANY_SANDBOX }
        it 'ignore default scope if current_sandbox_id=-1' do
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
            sandbox_with field: :another_sandbox_id
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

    describe '#self.current_sandbox_id' do
      context 'no value given' do
        it 'returns the current_sandbox_id from RequestStore' do
          expect(RequestStore.store).to receive(:[]=)
          expect(RequestStore.store).to receive(:[]).with(:current_sandbox_id).and_return(1)
          expect(subject.current_sandbox_id).to eq(1)
        end
      end
      context 'value given' do
        let(:v) { 2 }
        it 'sets new value in RequestStore and return it' do
          expect { subject.current_sandbox_id v }.to change { subject.current_sandbox_id }.to v
          expect(RequestStore.store[:current_sandbox_id]).to eq v
        end
      end
    end
    describe '#=' do
      let(:v) { 3 }
      it 'sets new value in RequestStore' do
        expect { subject.current_sandbox_id=v }.to change { subject.current_sandbox_id }.to v
        expect(RequestStore.store[:current_sandbox_id]).to eq v
      end
    end
  end
end