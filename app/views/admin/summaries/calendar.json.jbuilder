json.array! @tasks do |task|
  json.id          task.id
  json.task_name   task.task_name
  json.group_id    task.group_id
  json.status      task.status
end
