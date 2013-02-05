module V1
  class TimelineEntriesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
  
    # GET /timeline
    # GET /timeline.json
    def index
      @since_date = DateTime.new(0)
      if params[:since]
        @since_date = params[:since].to_datetime
      end
      
      #respond_with 
      @entries = TimelineEntry.all(:conditions => ["created_at > ?", @since_date], :order => "created_at DESC")
    end
  end
end
