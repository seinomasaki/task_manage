class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :intention
      t.timestamps
    end
  end
end
