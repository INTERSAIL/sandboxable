class CreateSandboxableModel < ActiveRecord::Migration
  def change
    create_table :sandboxable_models do |t|
      t.string :name
      t.integer :sandbox_id
      t.integer :another_sandbox_id
    end
  end
end