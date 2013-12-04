class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_type
      t.text :push_id
      t.string :name

      t.timestamps
    end
  end
end
