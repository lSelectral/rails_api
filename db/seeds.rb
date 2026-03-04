# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

demo_user = User.find_or_initialize_by(username: 'demo_user')
demo_user.password = 'Secret123!'
demo_user.password_confirmation = 'Secret123!'
demo_user.active = true
demo_user.credits = 100
demo_user.save!

demo_user_header = SmsHeader.find_or_initialize_by(user: demo_user, name: 'DEMOHDR')
demo_user_header.active = true
demo_user_header.save!

vip_user = User.find_or_initialize_by(username: 'vip_user')
vip_user.password = 'Secret123!'
vip_user.password_confirmation = 'Secret123!'
vip_user.active = true
vip_user.credits = 250
vip_user.save!

vip_user_header = SmsHeader.find_or_initialize_by(user: vip_user, name: 'VIPHDR')
vip_user_header.active = true
vip_user_header.save!

low_credit_user = User.find_or_initialize_by(username: 'low_credit_user')
low_credit_user.password = 'Secret123!'
low_credit_user.password_confirmation = 'Secret123!'
low_credit_user.active = true
low_credit_user.credits = 0
low_credit_user.save!

low_credit_user_header = SmsHeader.find_or_initialize_by(user: low_credit_user, name: 'LOWHDR')
low_credit_user_header.active = true
low_credit_user_header.save!

# Reports greater_than bug testi için demo_user üzerinde sabit kampanya
reports_campaign = SmsCampaign.find_or_initialize_by(user: demo_user, custom_id: 'seed-reports-001')
reports_campaign.source_addr = 'DEMOHDR'
reports_campaign.status = 'completed'
reports_campaign.total_messages = 3
reports_campaign.total_credits = 3
reports_campaign.save!

# Aynı custom_id ile tekilleştirerek idempotent mesaj üretimi
seed_messages = [
	{ custom_id: 'seed-msg-001', dest: '905551111111', msg: 'Seed message 1', status: 'DELIVERED' },
	{ custom_id: 'seed-msg-002', dest: '905552222222', msg: 'Seed message 2', status: 'DELIVERED' },
	{ custom_id: 'seed-msg-003', dest: '905553333333', msg: 'Seed message 3', status: 'SENT' }
]

seed_messages.each do |attrs|
	sms_message = SmsMessage.find_or_initialize_by(sms_campaign: reports_campaign, custom_id: attrs[:custom_id])
	sms_message.dest = attrs[:dest]
	sms_message.msg = attrs[:msg]
	sms_message.status = attrs[:status]
	sms_message.size = 1
	sms_message.international_multiplier = 1
	sms_message.credits = 1
	sms_message.save!
end

reports_campaign.update!(total_messages: reports_campaign.sms_messages.count)

puts "Seeded users: #{demo_user.username}, #{vip_user.username}, #{low_credit_user.username}"
puts "Seeded reports campaign: #{reports_campaign.id} (custom_id=#{reports_campaign.custom_id})"
