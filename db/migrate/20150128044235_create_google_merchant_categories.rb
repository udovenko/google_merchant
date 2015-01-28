class CreateGoogleMerchantCategories < ActiveRecord::Migration
  def self.up
    create_table :google_merchant_categories do |t|
      t.string  :name
      t.integer :parent_id
      t.integer :left
      t.integer :right
      t.timestamps
    end
    
    add_index :google_merchant_categories, :parent_id
    add_index :google_merchant_categories, :left
    add_index :google_merchant_categories, :right
  end

  def self.down
    drop_table :google_merchant_categories
  end
end
