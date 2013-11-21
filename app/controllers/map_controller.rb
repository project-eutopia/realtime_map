class MapController < ApplicationController
  # Number of seconds of recent purchase data that should be
  # gotten on a first load, and subsequent calls
  FIRST_QUERY_LENGTH_IN_SECONDS = 60
  REGULAR_QUERY_LENGTH_IN_SECONDS = 30
  
  MAX_NUMBER_OF_PURCHASES_PER_CALL = 100
  
  # map/index GET
  def index
    session[:start_time] = Time.now()
    session[:query_time] = session[:start_time]
    @purchases = Purchase.recent(seconds: FIRST_QUERY_LENGTH_IN_SECONDS,
                                 limit: MAX_NUMBER_OF_PURCHASES_PER_CALL,
                                 start_time: session[:start_time],
                                 query_time: session[:query_time])
    @data = {:markers => @purchases.collect {|p| p.circle_data} }
    
    respond_to do |format|
      format.html
    end
  end
  
  # map/index POST
  def query
    session[:query_time] = Time.now()
    @purchases = Purchase.recent(seconds: REGULAR_QUERY_LENGTH_IN_SECONDS,
                                 limit: MAX_NUMBER_OF_PURCHASES_PER_CALL,
                                 start_time: session[:start_time],
                                 query_time: session[:query_time])
    @data = {:markers => @purchases.collect {|p| p.circle_data} }
    
    respond_to do |format|
      format.json { render :json => @data.to_json }
    end

  end
end
