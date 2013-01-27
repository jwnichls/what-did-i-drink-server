class TimelineEntriesController < ApplicationController
  # GET /timeline_entries
  # GET /timeline_entries.json
  def index
    @since_date = DateTime.new(0)
    if params[:since]
      @since_date = params[:since].to_datetime
    end
    
    @timeline_entries = TimelineEntry.all(:conditions => ["created_at > ?", @since_date], :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timeline_entries }
    end
  end
end
