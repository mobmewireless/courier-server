class AddRegistrationTokenToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :registration_token, :string
    add_index :devices, :registration_token, unique: true
  end
end
