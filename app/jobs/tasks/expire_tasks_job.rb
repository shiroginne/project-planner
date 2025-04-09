class Tasks::ExpireTasksJob < ApplicationJob
  queue_as :default

  def perform
    Task.expired.find_each do |task|
      # Send notification, update status, etc.
      Rails.logger.info "Expired Task ##{task.id} handled"
    end
  end
end
