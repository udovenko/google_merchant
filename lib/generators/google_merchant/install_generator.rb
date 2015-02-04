module GoogleMerchant
  module Generators
    
    
    # Creates gem initializer.
    #
    # @author Denis Udovenko
    # @version 1.0.2
    class InstallGenerator < Rails::Generators::Base
      
      
      source_root File.expand_path("../../templates", __FILE__)
      
      
      desc "Creates google_merchant initializer and mounts routes for your application"

      
      # Copies initializer template to Rails initializers directory.
      def copy_initializer
        template "google_merchant_initializer.rb", "config/initializers/google_merchant.rb"
        puts "Installation complete!"
      end
      
      
      # Injects routes into application routes file:
      def mount_routes
        route "mount GoogleMerchant::Engine, at: '/google_merchant'"
      end
    end
  end
end