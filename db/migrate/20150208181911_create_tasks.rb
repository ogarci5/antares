class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.datetime :due_date
      t.boolean :completed, default: false
      t.string :type
      t.integer :priority

      t.timestamps null: false
    end
  end
end
