class Task < ApplicationRecord
  belongs_to :project
  belongs_to :parent, class_name: "Task", optional: true

  validates :name, presence: true

  scope :non_expired, -> { where("expires_at > ?", Time.current) }
  scope :expired,     -> { where("expires_at <= ?", Time.current) }

  before_create :set_default_expiration

  private

  def set_default_expiration
    self.expires_at ||= 6.months.from_now
  end
end
