require "rails_helper"

RSpec.describe Tasks::ExpireTasksJob, type: :job do
  let!(:project) { Project.create!(name: "Test Project") }

  let!(:expired_task) do
    project.tasks.create!(name: "Old Task", expires_at: 7.month.ago)
  end

  let!(:active_task) do
    project.tasks.create!(name: "Active Task", expires_at: 1.month.from_now)
  end

  it "processes only expired tasks" do
    expect(Rails.logger).to receive(:info).with("Expired Task ##{expired_task.id} handled")

    described_class.new.perform
  end

  it "does not raise errors when no expired tasks exist" do
    Task.delete_all

    expect {
      described_class.new.perform
    }.not_to raise_error
  end
end
