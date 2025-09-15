class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.1]
  def up
    # First, update any existing string values to integers
    execute "UPDATE users SET role = '2' WHERE role IS NULL OR role = ''"
    execute "UPDATE users SET role = '0' WHERE role = 'admin'"
    execute "UPDATE users SET role = '1' WHERE role = 'manager'"
    execute "UPDATE users SET role = '2' WHERE role = 'member'"
    
    # Then change the column type
    change_column :users, :role, :integer, using: 'role::integer', default: 2
  end
  
  def down
    change_column :users, :role, :string
  end
end
