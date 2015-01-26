module GoogleMerchant
  
  
  #
  #
  #
  class Configuration
    attr_accessor :feed_title, :feed_updated
    
    
    # Public constructor. Sets up configuration defaults.
    def initialize
      @feed_title = "My Google Merchant Feed"
      @feed_updated = Proc.new { Time.zone.now }
    end
  end
end