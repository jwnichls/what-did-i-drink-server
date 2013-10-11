module V1
  class TimelineEntriesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    respond_to :json
  
    # GET /timeline
    # GET /timeline.json
    def index
      pagesize = params[:pagesize].nil? ? 20 : params[:pagesize]
      since = DateTime.new(0)
      if params[:since]
        begin
          since = params[:since].to_datetime
        rescue
        end
      end
      
      if params[:page] && params[:page] == "all"
        @entries = TimelineEntry.where(["created_at > ?", since]).order("created_at DESC").all
      else
        @entries = TimelineEntry.where(["created_at > ?", since]).order("created_at DESC").paginate(:per_page => pagesize, :page => params[:page])
      end
    end
  end
end
