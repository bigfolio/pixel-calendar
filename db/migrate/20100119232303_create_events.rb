class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.string :name
      t.string :venue_name
      t.string :organizer
      t.text :address
      t.string :city
      t.string :state
      t.string :zip
      t.float :lat
      t.float :lng
      t.date :starts_on
      t.date :ends_on
      t.time :starts_at
      t.time :ends_at
      t.boolean :all_day, :default => false
      t.boolean :multi_day, :default => false
      
      t.text :description
      t.string :website
      
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :sell_tickets
      t.integer :number_of_tickets


      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
