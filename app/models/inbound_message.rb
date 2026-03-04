class InboundMessage < ApplicationRecord
  belongs_to :user

  validates :source_addr, presence: true
  validates :destination_addr, presence: true
  validates :content, presence: true
end
