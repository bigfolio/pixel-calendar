require 'icalendar'

class SiteController < ApplicationController
  
  def index
    
    @upcoming = Event.upcoming
    @recently_added = Event.recently_added
    
    render :layout => 'home'
  end

  def calendar
    @events = Event.all
    @calendar = Icalendar::Calendar.new
    
    @events.each do |e|
      event = Icalendar::Event.new
      event.start = e.starts_on.strftime("%Y%m%dT%H%M%S")
      event.end = e.ends_on.strftime("%Y%m%dT%H%M%S") unless e.ends_on.nil?
      event.summary = e.name
      event.description = e.description
      event.location = e.venue_name
      @calendar.add event
      # response.headers['Content-Type'] = "text/calendar; charset=UTF-8"
    end
    @calendar.publish
    render :text => @calendar.to_ical, :layout => false, :content_type => "text/calendar; charset=UTF-8"
    
  end
  
end
