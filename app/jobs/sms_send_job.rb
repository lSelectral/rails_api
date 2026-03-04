class SmsSendJob < ApplicationJob
  queue_as :default

  def perform(campaign_id)
    campaign = SmsCampaign.find_by(id: campaign_id)
    return unless campaign

    campaign.update!(status: 'sending')

    campaign.sms_messages.each do |message|
      # Simüle edilmiş gönderim
      statuses = ['DELIVERED', 'NOT_DELIVERED', 'EXPIRED', 'WAITING']
      final_status = statuses.sample

      message.update!(
        status: final_status,
        sent_at: final_status == 'DELIVERED' ? Time.current : nil,
        done_at: Time.current
      )
    end

    campaign.update!(status: 'completed')

    total_credits = campaign.sms_messages.sum(:credits)
    campaign.user.deduct_credits!(total_credits)
  end
end
