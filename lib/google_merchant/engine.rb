module GoogleMerchant
  class Engine < ::Rails::Engine
    isolate_namespace GoogleMerchant
    
    # Add a load path for this specific Engine
    def self.path_to_views
      File.expand_path("../../app/views", File.dirname(__FILE__))
    end
  end
end
