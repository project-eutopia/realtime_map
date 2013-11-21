class MapController < ApplicationController
  # Number of seconds of recent purchase data that should be
  # gotten on a first load, and subsequent calls
  FIRST_QUERY_LENGTH_IN_SECONDS = 20
  REGULAR_QUERY_LENGTH_IN_SECONDS = 20
  
  MAX_NUMBER_OF_PURCHASES_PER_CALL = 100
  
  # map/index GET
  def index
    session[:start_time] = Time.now()
    session[:query_time] = session[:start_time]
    @purchases = Purchase.recent(seconds: FIRST_QUERY_LENGTH_IN_SECONDS,
                                      limit: MAX_NUMBER_OF_PURCHASES_PER_CALL)
    @data = {:markers => @purchases.collect {|p| p.circle_data} }
    
    respond_to do |format|
      format.html
    end
  end
  
  # map/index POST
  def query
    # Time of previous query is: params[:last_query]
    session[:query_time] = Time.now()
    @purchases = Purchase.recent(seconds: REGULAR_QUERY_LENGTH_IN_SECONDS,
                                      limit: MAX_NUMBER_OF_PURCHASES_PER_CALL)
    @data = {:markers => @purchases.collect {|p| p.circle_data} }
    
    respond_to do |format|
      format.json { render :json => @data.to_json }
    end

  end
end
