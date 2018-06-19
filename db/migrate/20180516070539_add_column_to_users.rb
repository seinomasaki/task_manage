class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password, :string
    add_column :users, :general, :string
    # add_index :users, %i[name email], unique: true
  end
end
