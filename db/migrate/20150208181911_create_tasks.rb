class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :goal
      t.text :description
      t.date :due_date
      t.boolean :completed
      t.string :type
      t.integer :priority

      t.timestamps null: false
    end
  end
end
