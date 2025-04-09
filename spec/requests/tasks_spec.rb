require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let!(:project) { Project.create!(name: "Test Project") }
  let!(:task)    { project.tasks.create!(name: "Sample Task", expires_at: 1.month.from_now) }

  describe "POST /projects/:project_id/tasks" do
    it "creates a new task for project" do
      expect {
        post project_tasks_path(project), params: { task: { name: "New Task" } }
      }.to change(Task, :count).by(1)

      follow_redirect! if response.redirect?
      expect(Task.last.name).to eq("New Task")
    end
  end

  describe "PATCH /projects/:project_id/tasks/:id" do
    it "updates the task name" do
      patch project_task_path(project, task),
        params: { task: { name: "Updated Task" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:ok).or have_http_status(:redirect)
      expect(task.reload.name).to eq("Updated Task")
    end
  end

  describe "DELETE /projects/:project_id/tasks/:id" do
    it "deletes the task" do
      expect {
        delete project_task_path(project, task)
      }.to change(Task, :count).by(-1)
    end
  end
end
