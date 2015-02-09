module GoogleMerchant
  
  
  #
  #
  class ApplicationController < ActionController::Base
    
    
    #
    #
    def feed
      @configuration = GoogleMerchant::configuration.dup;
      
      # Replace file path with module name and file name with name of method:
      @configuration.feed_file_path = self.class.name.split("::").first.underscore + "/"
      @configuration.feed_file_name = __method__
            
      respond_to do |format|
        format.atom { render :layout => false }
      end
    end
  end
end
