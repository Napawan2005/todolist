json.extract! task, :id, :title, :due_date, :completed, :created_at, :updated_at
json.url task_url(task, format: :json)
