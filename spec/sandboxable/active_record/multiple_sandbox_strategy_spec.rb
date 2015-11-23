require 'spec_helper'

module Sandboxable
  module ActiveRecord
    describe MultipleSandboxStrategy do
      before do
        # This strategy uses multiple sandbox_ids separated by comma ","
        Sandboxable::ActiveRecord.current_sandbox_id "1,2,3,4,5"
        @s1 = SandboxableModel.without_sandbox {|obj| obj.create(name: "model_1")}
        @s1.update_column(:sandbox_id, 1)
        @s2 = SandboxableModel.without_sandbox {|obj| obj.create(name: "model_2")}
        @s2.update_column(:sandbox_id, 2)
        @s3 = SandboxableModel.without_sandbox {|obj| obj.create(name: "model_3")}
        @s3.update_column(:sandbox_id, 3)

        SandboxableModel.class_eval do
          sandbox_with set_sandbox_proc: MultipleSandboxStrategy.default_set_proc do
            MultipleSandboxStrategy.default_proc
          end
        end
      end

      after do
        SandboxableModel.class_eval do
          sandbox_with
        end
      end
      describe '#self.default_proc' do
        it 'filters using all the sandbox ids' do
          expect(SandboxableModel.all).to eq([@s1,@s2,@s3])
        end
      end

      describe '#self.default_set_proc' do
        it 'sets the first sandbox_id found in the sandbox id csv list' do
          expect(SandboxableModel.create(name: "model_with_multiple_sandboxes").sandbox_id).to eq(1)
        end
      end
    end
  end
end