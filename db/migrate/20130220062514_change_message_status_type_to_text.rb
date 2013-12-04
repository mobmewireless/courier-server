class ChangeMessageStatusTypeToText < ActiveRecord::Migration
  def change
    change_column :messages, :status, :text
  end
end
