module V1
  class TimelineEntriesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
  
    # GET /timeline
    # GET /timeline.json
    def index
      respond_with TimelineEntry.all(:order => "created_at DESC")
    end
  end
end
