class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :notification
      t.integer :status

      t.timestamps
    end
  end
end
