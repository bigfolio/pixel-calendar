class Event < ActiveRecord::Base
  
  validates_presence_of :name, :venue_name, :starts_on, :description
  
  validates_numericality_of :price, :allow_nil => true
  
  belongs_to :user
  before_validation :geocode_address
  after_save :geocode_address
  
  acts_as_mappable
  
  include GeoKit::Geocoders
  
  def self.upcoming(limit = 10)
    events = find(:all, :order => 'starts_on ASC', :conditions => ["starts_on > ?", Time.now], :limit => limit)
  end
  
  def self.recently_added(limit = 10)
    events = find(:all, :order => 'created_at DESC', :conditions => ["starts_on > ?", Time.now], :limit => limit)
  end
  
  def geocode
    @geocode ||= GoogleGeocoder.geocode(self.map_address)
  end
  
  def map_address
    "#{self.address} #{self.city},#{self.state} #{self.zip}"
  end
  
  def display_address(divider = '<br />')
    "#{self.venue_name}#{divider}#{self.address} #{divider}#{self.city}, #{self.state} #{self.zip}"
  end
  
  def city_state
    "#{self.city}, #{self.state}"
  end
  
  private
  
    def geocode_address
      geo=GeoKit::Geocoders::MultiGeocoder.geocode(map_address)
      errors.add(:address, "Could not Geocode address") if !geo.success
      self.lat, self.lng = geo.lat,geo.lng if geo.success
    end
  
end
