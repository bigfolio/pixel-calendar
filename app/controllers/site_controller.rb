require 'icalendar'

class SiteController < ApplicationController
  
  def index
    @upcoming = Event.upcoming
    @recently_added = Event.recently_added    
    render :layout => 'home'
  end
  
  def search
    search_condition = "%" + params[:q] + "%"
    @events = Event.find(:all, :conditions => ['name LIKE ? OR description LIKE ?', search_condition, search_condition])
  end

  def calendar
    @events = Event.all
    @calendar = Icalendar::Calendar.new
    @calendar.custom_property('X-WR-CALNAME','PixelCal Photo/Video Events')
    @events.each do |e|
      event = Icalendar::Event.new
      event.start = e.starts_on.strftime("%Y%m%dT%H%M%S")
      event.end = e.ends_on.strftime("%Y%m%dT%H%M%S") unless e.ends_on.nil?
      event.summary = e.name
      event.description = e.description.blank? ? 'No description available' : e.description.gsub(/<\/?[^>]*>/, "") 
      event.location = "#{e.venue_name} (#{e.city})"
      event.url = url_for e
      event.uid = "#{e.id}@pixelcal.com"
      @calendar.add event
      # response.headers['Content-Type'] = "text/calendar; charset=UTF-8"
    end
    @calendar.publish
    render :text => @calendar.to_ical, :layout => false, :content_type => "text/calendar; charset=UTF-8"
    
  end
  
end
