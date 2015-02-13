class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.date :date
      t.text :description
      t.string :value

      t.timestamps null: false
    end
  end
end
