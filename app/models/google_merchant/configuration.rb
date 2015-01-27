module GoogleMerchant
  
  
  #
  #
  #
  class Configuration
    attr_accessor :host, :protocol, :path, :feed_title, :feed_updated
    
    
    # Public constructor. Sets up configuration defaults.
    def initialize
      @host = "myhost.com"
      @protocol = "http"
      @path = "/google_merchant.atom"
      @feed_title = "My Google Merchant Feed"
      @feed_updated = Proc.new { Time.zone.now }
    end
  end
end