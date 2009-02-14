class CreateHearts < ActiveRecord::Migration
  def self.up
    create_table :hearts do |t|
      t.string :name
      t.timestamps
      t.integer :items_count, :default=>0
    end
  end
  
  def self.down
    drop_table :hearts
  end
end
