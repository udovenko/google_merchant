module GoogleMerchant
  
  
  #
  #
  #
  class FeedController < ApplicationController
    
    
    #
    #
    def index
      @configuration = GoogleMerchant::configuration;
      
      request.format = "atom" unless params[:format]
      respond_to do |format|
        format.atom { render :layout => false }
      end
    end
  end
end