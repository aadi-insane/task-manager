class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.integer :parent_id
      t.references :assignee, null: true, foreign_key: { to_table: :users }
      t.integer :status, default: 0
      t.integer :priority, default: 1
      t.datetime :starts_at
      t.datetime :due_at

      t.timestamps
    end
  end
end
