class CreateInventoryStorages < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_storages do |t|
      t.string :title

      t.timestamps
    end
  end
end
