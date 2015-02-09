module GoogleMerchant
  
  
  # Plugin configuration class.
  #
  # @author Denis Udovenko
  # @version 1.0.4
  class Configuration
    
    
    attr_accessor :taxonomy_file_url, :language, :host, :protocol, 
      :feed_file_path, :feed_file_name, :feed_file_format, :feed_title, 
      :feed_updated, :entries
    
    
    # Public constructor. Sets up configuration defaults.
    def initialize
      @taxonomy_file_url = "http://www.google.com/basepages/producttype/taxonomy.en-US.txt"
      @language = "en-US"
      @host = "myhost.com"
      @protocol = "http"
      @feed_file_path = ""
      @feed_file_name = "google_merchant"
      @feed_file_format = "atom"
      @feed_title = "My Google Merchant Feed"
      @feed_updated = Proc.new { Time.zone.now }
      @entries = []
    end
  end
end