require 'icalendar'

class EventsController < ApplicationController

  before_filter :login_required, :only => [:new, :create, :edit]
  before_filter :can_edit?, :only => [:edit, :update]


  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @page_title = "#{@event.name} (#{@event.city})"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
      format.ics do
        @calendar = Icalendar::Calendar.new
        @calendar.custom_property('X-WR-CALNAME','PixelCal Photo/Video Events')
        event = Icalendar::Event.new
        event.start = @event.starts_on.strftime("%Y%m%d")
        event.end = @event.ends_on.strftime("%Y%m%d") unless @event.ends_on.nil?
        event.summary = @event.name
        event.description = @event.description.blank? ? 'No description available' : @event.description.gsub(/<\/?[^>]*>/, "") 
        event.location = "#{@event.venue_name} (#{@event.city})"
        event.url = url_for @event
        event.uid = "#{@event.id}@pixelcal.com"
        @calendar.add event
        @calendar.publish
        send_data @calendar.to_ical, :layout => false, :content_type => "text/calendar; charset=UTF-8", :disposition => "inline; filename=pixelcal.ics", :filename => "pixelcal.ics"
      end
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
    def can_edit? 
      redirect_to root_url unless current_user && current_user.events.include?(Event.find(params[:id]))
    end
  
end
