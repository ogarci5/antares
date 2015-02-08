class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.references :task, index: true
      t.date :date
      t.text :description
      t.string :value

      t.timestamps null: false
    end
    add_foreign_key :progresses, :tasks
  end
end
