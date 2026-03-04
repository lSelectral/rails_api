class CreateUsers < ActiveRecord::Migration[7.1]
	def change
		create_table :users do |t|
			t.string :username, null: false
			t.string :password_digest, null: false
			t.decimal :credits, precision: 10, scale: 2, default: "100.0"
			t.boolean :active, default: true

			t.timestamps
		end

		add_index :users, :username, unique: true
	end
end
