class CreateSmsHeaders < ActiveRecord::Migration[7.1]
  def change
    create_table :sms_headers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
