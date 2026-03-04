class SmsCampaign < ApplicationRecord
  belongs_to :user
  has_many :sms_messages, dependent: :destroy

  STATUSES = %w[pending sending completed cancelled failed].freeze

  validates :status, inclusion: { in: STATUSES }

  scope :active, -> { where(status: ['pending', 'sending']) }
  scope :cancellable, -> { where(status: 'cancelled') }

  def cancel!
    return false if status == 'completed'
    update!(status: 'cancelled')
  end
end
