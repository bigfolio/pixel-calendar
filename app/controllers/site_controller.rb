class SiteController < ApplicationController
  
  def index
    
    @upcoming = Event.upcoming
    @recently_added = Event.recently_added
    
    render :layout => 'home'
  end
  
end
