module GoogleMerchant
  
  
  #
  #
  class ApplicationController < ActionController::Base
    
    
    #
    #
    def show
      @configuration = GoogleMerchant::configuration;
      
      request.format = "atom" unless params[:format]
      respond_to do |format|
        format.atom { render :layout => false }
      end
    end
  end
end
