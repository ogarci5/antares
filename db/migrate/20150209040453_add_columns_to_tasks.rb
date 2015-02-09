class AddColumnsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :recurring, :boolean
    add_column :tasks, :period, :string
    add_column :tasks, :remind_me, :boolean
    add_column :tasks, :last_completed_at, :datetime
    add_column :tasks, :task_id, :integer

    add_index :tasks, :task_id
  end
end
