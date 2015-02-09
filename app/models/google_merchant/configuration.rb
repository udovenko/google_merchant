module GoogleMerchant
  
  
  # Plugin configuration class.
  #
  # @author Denis Udovenko
  # @version 1.0.3
  class Configuration
    
    
    attr_accessor :taxonomy_file_url, :language, :host, :protocol, :feed_path, 
      :feed_format, :feed_title, :feed_updated, :entries
    
    
    # Public constructor. Sets up configuration defaults.
    def initialize
      @taxonomy_file_url = "http://www.google.com/basepages/producttype/taxonomy.en-US.txt"
      @language = "en-US"
      @host = "myhost.com"
      @protocol = "http"
      @feed_path = "google_merchant"
      @feed_format = "atom"
      @feed_title = "My Google Merchant Feed"
      @feed_updated = Proc.new { Time.zone.now }
      @entries = []
    end
  end
end