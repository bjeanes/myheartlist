class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :user
      t.references :heart
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :items
  end
end
