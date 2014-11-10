module TasksIframeHelper
  def tasks_iframe_path
    'http://localhost:3333/tasks' if Rails.env.development?
  end
end