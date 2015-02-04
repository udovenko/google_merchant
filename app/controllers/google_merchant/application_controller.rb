module GoogleMerchant
  
  
  #
  #
  class ApplicationController < ActionController::Base
    
    
    #
    #
    def feed
      @configuration = GoogleMerchant::configuration;
      
      respond_to do |format|
        format.atom { render :layout => false }
      end
    end
  end
end
