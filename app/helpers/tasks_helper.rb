module TasksHelper
  def task_list_group_class(task)
    if task.past_due?
      task.completed? ? 'list-group-item-success' : 'list-group-item-danger'
    else
      ''
    end
  end
end
