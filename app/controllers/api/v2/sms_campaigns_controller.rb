module Api
  module V2
    class SmsCampaignsController < ApplicationController
      # GET /api/v2/send
      def send_sms
        dest = params[:dest]
        msg  = params[:msg]

        return render plain: 'MISSING_DESTINATION_ADDRESS', status: :bad_request if dest.blank?
        return render plain: 'MISSING_MESSAGE', status: :bad_request if msg.blank?

        dest_numbers = dest.split(',').map(&:strip)

        # Numara validasyonu
        dest_numbers.each do |number|
          unless valid_phone?(number)
            return render plain: 'INVALID_DESTINATION_ADDRESS', status: :bad_request
          end
        end

        source_addr = params[:source_addr] || current_user.sms_headers.active.first&.name
        return render plain: 'INVALID_SOURCE_ADDRESS', status: :bad_request if source_addr.blank?

        # Kredi kontrolü
        total_credits = dest_numbers.count
        unless current_user.has_sufficient_credits?(total_credits)
          return render plain: 'INSUFFICIENT_CREDITS', status: :payment_required
        end

        campaign = SmsCampaign.create!(
          user: current_user,
          custom_id: params[:custom_id],
          source_addr: source_addr,
          valid_for: params[:valid_for] || '24:00',
          datacoding: params[:datacoding] || 0,
          send_at: params[:send_at].present? ? Time.parse(params[:send_at]) : nil,
          status: 'pending',
          total_messages: dest_numbers.count
        )

        dest_numbers.each do |number|
          SmsMessage.create!(
            sms_campaign: campaign,
            dest: number,
            msg: msg,
            status: 'SENDING'
          )
        end

        # Sidekiq job ile gönderim
        SmsSendJob.perform_later(campaign.id)

        render plain: campaign.id.to_s, status: :ok
      end

      private

      def valid_phone?(number)
        # Yurt içi: 905XXXXXXXXX veya yurt dışı: 00XXXX ya da +XXXX
        number.match?(/\A(905\d{9}|00\d{10,14}|\+\d{10,15})\z/)
      end
    end
  end
end
