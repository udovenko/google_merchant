namespace :google_merchant do
  
  
  desc "Google Merchant plugin tasks"
  
  
  # Updates categories tree from Google product categories remote file.
  task update: :environment do
    GoogleMerchant::Category.verbose = true
    GoogleMerchant::Category.update
  end
  
  
  # Generates Atom feed for Google Merchant in Rails application's public 
  # directory. 
  task generate: :environment do
    
    # Bring ActionDispatch::Routing::UrlFor helpers:
    include Rails.application.routes.url_helpers 
    include ActionView::Helpers::TagHelper

    action_view = ActionView::Base.new(GoogleMerchant::Engine.path_to_views)
    action_view.assign({
      :configuration => GoogleMerchant::configuration
    })
    
    puts "Building Atom feed file #{GoogleMerchant::configuration.path}..."
    
    feed_file = File.new("public/#{GoogleMerchant::configuration.path}", 'w')
    feed_file.puts(action_view.render(:template => "google_merchant/application/feed"))
    feed_file.close
    
    puts "Atom feed file was built successfully!"
  end
end