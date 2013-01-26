class TimelineEntriesController < ApplicationController
  # GET /timeline_entries
  # GET /timeline_entries.json
  def index
    @timeline_entries = TimelineEntry.all(:order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timeline_entries }
    end
  end
end
