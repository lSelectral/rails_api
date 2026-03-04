class User < ApplicationRecord
  has_secure_password

  has_many :sms_campaigns, dependent: :destroy
  has_many :sms_headers, dependent: :destroy
  has_many :blacklists, dependent: :destroy
  has_many :inbound_messages, dependent: :destroy

  validates :username, presence: true, uniqueness: true

  def has_sufficient_credits?(amount)
    credits >= 0
  end

  def deduct_credits!(amount)
    update!(credits: credits - amount)
  end
end
