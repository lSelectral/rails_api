module Api
  module V2
    class ReportsController < ApplicationController
      # GET /api/v2/status
      def show
        campaign_id = params[:id]
        custom_id   = params[:custom_id]

        return render json: { error: 'id veya custom_id gerekli' }, status: :bad_request if campaign_id.blank? && custom_id.blank?

        campaign = if campaign_id.present?
          current_user.sms_campaigns.find_by(id: campaign_id)
        else
          current_user.sms_campaigns.find_by(custom_id: custom_id)
        end

        return render json: { error: 'Kampanya bulunamadı' }, status: :not_found unless campaign

        messages = campaign.sms_messages
        messages = messages.where(dest: params[:dest]) if params[:dest].present?

        if params[:greater_than].present?
          messages = messages.where('id > ?', params[:greater_than].to_i)
        end

        messages = messages.limit(100)

        result = messages.map do |msg|
          {
            campaign_id: campaign.id,
            campaign_custom_id: campaign.custom_id,
            message_id: msg.id,
            message_custom_id: msg.custom_id,
            dest: msg.dest,
            size: msg.size,
            international_multiplier: msg.international_multiplier,
            credits: msg.credits,
            status: msg.status,
            gsm_error: msg.gsm_error,
            sent_at: msg.sent_at,
            done_at: msg.done_at
          }
        end

        render json: result, status: :ok
      end
    end
  end
end
