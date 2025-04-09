require "rails_helper"

RSpec.describe Task, type: :model do
  let(:project) { Project.create!(name: "Test Project") }

  it "is valid with a name and expires_at" do
    task = project.tasks.build(name: "Do the thing", expires_at: 2.months.from_now)
    expect(task).to be_valid
  end

  it "is invalid without a name" do
    task = project.tasks.build(name: nil, expires_at: 1.month.from_now)
    expect(task).not_to be_valid
    expect(task.errors[:name]).to include("can't be blank")
  end

  describe ".non_expired and .expired scopes" do
    let!(:expired_task) { project.tasks.create!(name: "Old", expires_at: 1.day.ago) }
    let!(:active_task)  { project.tasks.create!(name: "Fresh", expires_at: 1.month.from_now) }

    it "returns only tasks that are not expired" do
      expect(Task.non_expired).to include(active_task)
      expect(Task.non_expired).not_to include(expired_task)
    end

    it "returns only tasks that are expired" do
      expect(Task.expired).to include(expired_task)
      expect(Task.expired).not_to include(active_task)
    end
  end

  it "can optionally belong to a parent task" do
    parent = project.tasks.create!(name: "Parent Task", expires_at: 1.month.from_now)
    child = project.tasks.build(name: "Child Task", expires_at: 1.month.from_now, parent: parent)

    expect(child).to be_valid
    expect(child.parent).to eq(parent)
  end
end
