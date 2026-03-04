class CreateSmsMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :sms_messages do |t|
      t.references :sms_campaign, null: false, foreign_key: true
      t.string :custom_id
      t.string :dest, null: false
      t.text :msg, null: false
      t.integer :size, default: 1
      t.integer :international_multiplier, default: 1
      t.decimal :credits, precision: 10, scale: 2, default: "1"
      t.string :status, default: "SENDING"
      t.string :gsm_error
      t.datetime :sent_at
      t.datetime :done_at

      t.timestamps
    end
    add_index :sms_messages, :dest
    add_index :sms_messages, :status
  end
end
