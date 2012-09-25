module TasksHelper
  # Friendly title for this task
  def task_title(task, link_to_person = false)
    p = task.person
    raw( task.task_type.title_template.sub(/<name>/, link_to_person ? ( link_to p.name, p ) : p.name) )
  end
end
