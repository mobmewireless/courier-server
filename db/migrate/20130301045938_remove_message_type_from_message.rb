class RemoveMessageTypeFromMessage < ActiveRecord::Migration
  def up
    remove_column :messages, :message_type
  end

  def down
    add_column :messages, :message_type, :string
  end
end
