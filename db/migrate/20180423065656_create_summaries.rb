class CreateSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :summaries do |t|
      t.string :task_name
      t.string :label
      t.text :contents
      t.datetime :time_limit
      t.string :status
      t.string :priority
      t.datetime :created_at, default: -> { 'NOW()' }
      t.datetime :updated_at, default: -> { 'NOW()' }
      t.boolean :disp_flag, default:false
      t.boolean :delete_flag, default:false

      t.timestamps
    end
  end
end
