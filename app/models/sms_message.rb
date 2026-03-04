class SmsMessage < ApplicationRecord
  belongs_to :sms_campaign

  STATUSES = %w[SENDING WAITING DELIVERED SENT NOT_DELIVERED EXPIRED
                INVALID_DESTINATION_ADDRESS REJECTED DOUBLE_SEND_ERROR
                BLACKLISTED_DESTINATION_ADDRESS NOT_ALLOWED_BY_IYS].freeze

  validates :dest, presence: true
  validates :msg, presence: true
  validates :status, inclusion: { in: STATUSES }

  def has_turkish_chars?
    turkish_chars = ['ş', 'Ş', 'ğ', 'Ğ', 'ç', 'ı', 'İ']
    turkish_chars.any? { |char| msg.include?(char) }
  end
end
