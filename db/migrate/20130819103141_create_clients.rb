class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :access_token, unique: true
      t.integer :user_id

      t.timestamps
    end

    add_index :clients, :user_id
  end
end
