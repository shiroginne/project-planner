# app/queries/task_query.rb
class TaskQuery
  attr_reader :project, :filter

  def initialize(project:, filter: "active")
    @project = project
    @filter = filter
  end

  def call
    scope = case filter
    when "expired"
              project.tasks.expired
    else
              project.tasks.non_expired
    end

    scope.order(Arel.sql("CASE WHEN completed_at IS NULL THEN 0 ELSE 1 END, completed_at ASC"))
  end
end
