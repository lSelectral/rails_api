class Blacklist < ApplicationRecord
  belongs_to :user

  validates :phone, presence: true
  validates :phone, uniqueness: { scope: :user_id }
  validate :valid_phone_format

  private

  def valid_phone_format
    unless phone.match?(/\A905\d{9}\z/)
      errors.add(:phone, 'geçersiz format (905XXXXXXXXX olmalı)')
    end
  end
end
