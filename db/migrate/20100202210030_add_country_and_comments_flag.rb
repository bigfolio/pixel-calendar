class AddCountryAndCommentsFlag < ActiveRecord::Migration
  def self.up
    add_column :events, :comments, :boolean
    add_column :events, :country, :string
  end

  def self.down
    remove_column :events, :comments
    remove_column :events, :country
  end
end
