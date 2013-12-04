class AddDefaultValueToStatus < ActiveRecord::Migration
  def up
    remove_column :messages, :status
    add_column :messages, :status, :string, :default => 'pending'
  end

  def down
    remove_column :messages, :status
    add_column :messages, :status, :text
  end
end
