class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.text :description
      t.date :due_date
      t.boolean :completed, default: false
      t.integer :priority

      t.timestamps null: false
    end
  end
end
