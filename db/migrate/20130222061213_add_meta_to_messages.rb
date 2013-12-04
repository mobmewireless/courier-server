class AddMetaToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :meta, :text
  end
end
