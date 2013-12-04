class RenameMessageNotificationToContent < ActiveRecord::Migration
  def change
    rename_column :messages, :notification, :content
  end
end
