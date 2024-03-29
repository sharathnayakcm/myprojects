class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.float :price
      t.integer :quantity
      t.integer :product_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
