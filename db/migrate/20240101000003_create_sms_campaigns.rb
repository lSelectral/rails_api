class CreateSmsCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :sms_campaigns do |t|
      t.references :user, null: false, foreign_key: true
      t.string :custom_id
      t.string :source_addr
      t.string :valid_for, default: "24:00"
      t.integer :datacoding, default: 0
      t.boolean :is_commercial, default: false
      t.string :iys_recipient_type
      t.datetime :send_at
      t.string :status, default: "pending"
      t.integer :total_messages, default: 0
      t.decimal :total_credits, precision: 10, scale: 2, default: "0"

      t.timestamps
    end
    add_index :sms_campaigns, :custom_id
    add_index :sms_campaigns, :status
  end
end
