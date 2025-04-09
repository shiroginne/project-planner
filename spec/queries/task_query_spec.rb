require "rails_helper"

RSpec.describe TaskQuery do
  let!(:project) { Project.create!(name: "Test Project") }

  let!(:active_task_1) { project.tasks.create!(name: "Active 1", expires_at: 1.week.from_now, completed_at: nil) }
  let!(:active_task_2) { project.tasks.create!(name: "Active 2", expires_at: 1.week.from_now, completed_at: 1.day.ago) }
  let!(:expired_task)  { project.tasks.create!(name: "Expired", expires_at: 1.month.ago) }

  describe "#call" do
    context "when filter is 'active'" do
      it "returns non-expired tasks ordered by completed_at" do
        result = TaskQuery.new(project: project, filter: "active").call
        expect(result).to eq([active_task_1, active_task_2])
      end
    end

    context "when filter is 'expired'" do
      it "returns only expired tasks" do
        result = TaskQuery.new(project: project, filter: "expired").call
        expect(result).to include(expired_task)
        expect(result).not_to include(active_task_1, active_task_2)
      end
    end

    context "when filter is missing" do
      it "defaults to 'active'" do
        result = TaskQuery.new(project: project).call
        expect(result).to include(active_task_1, active_task_2)
        expect(result).not_to include(expired_task)
      end
    end
  end
end
