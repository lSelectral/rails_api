class CreateBlacklists < ActiveRecord::Migration[7.1]
  def change
    create_table :blacklists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone, null: false

      t.timestamps
    end
    add_index :blacklists, [:user_id, :phone], unique: true
  end
end
