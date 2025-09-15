class CreateTaskDependencies < ActiveRecord::Migration[7.1]
  def change
    create_table :task_dependencies do |t|
      t.bigint :predecessor_id
      t.bigint :successor_id
      t.string :dependency_type

      t.timestamps
    end
  end
end
