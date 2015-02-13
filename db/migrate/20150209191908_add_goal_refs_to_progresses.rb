class AddGoalRefsToProgresses < ActiveRecord::Migration
  def change
    add_reference :progresses, :goal, index: true
    add_foreign_key :progresses, :goals
  end
end
