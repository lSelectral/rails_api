class CreateInboundMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :inbound_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.string :network
      t.string :source_addr
      t.string :destination_addr
      t.string :keyword
      t.text :content
      t.datetime :received_at

      t.timestamps
    end
  end
end
