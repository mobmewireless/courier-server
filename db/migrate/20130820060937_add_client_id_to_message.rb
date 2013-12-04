class AddClientIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :client_id, :integer
    add_index :messages, :client_id
  end
end
