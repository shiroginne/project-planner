require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let!(:project) { Project.create!(name: "Test Project") }

  describe "GET /projects" do
    it "returns a list of projects" do
      get projects_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Test Project")
    end
  end

  describe "GET /projects/:id" do
    it "returns project details" do
      get project_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(project.name)
    end
  end

  describe "POST /projects" do
    it "creates a new project" do
      expect {
        post projects_path, params: { project: { name: "New Project" } }
      }.to change(Project, :count).by(1)

      follow_redirect!
      expect(response.body).to include("New Project")
    end
  end

  describe "DELETE /projects/:id" do
    it "deletes the project" do
      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)
    end
  end
end
