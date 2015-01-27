module GoogleMerchant
  
  
  #
  #
  #
  class Configuration
    attr_accessor :language, :host, :protocol, :path, :feed_title, :feed_updated, :entries
    
    
    # Public constructor. Sets up configuration defaults.
    def initialize
      @language = "en-US"
      @host = "myhost.com"
      @protocol = "http"
      @path = "/google_merchant.atom"
      @feed_title = "My Google Merchant Feed"
      @feed_updated = Proc.new { Time.zone.now }
      @entries = []
    end
  end
end