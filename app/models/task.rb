class Task < ActiveRecord::Base
  default_scope ->{ order('priority DESC, due_date ASC') }
end
