require "google_merchant/engine"

module GoogleMerchant
  
  
  class << self
    attr_accessor :configuration
  end

  
  # Creates gem configuration instance. Accepts block with configuration 
  # instructions.
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
