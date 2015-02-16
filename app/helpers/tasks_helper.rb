module TasksHelper
  def task_list_group_class(task)
    if task.past_due?
      task.completed? ? 'list-group-item-danger':'list-group-item-success'
    else
      ''
    end
  end
end
