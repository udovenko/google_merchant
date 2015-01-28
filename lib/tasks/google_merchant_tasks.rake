namespace :google_merchant do
  desc "Generates Google Merchant feed file"
  
  
  task generate: :environment do
    
    # Bring ActionDispatch::Routing::UrlFor:
    include Rails.application.routes.url_helpers 
    include ActionView::Helpers::TagHelper

    action_view = ActionView::Base.new(GoogleMerchant::Engine.path_to_views)
    action_view.assign({
      :configuration => GoogleMerchant::configuration
    })
    
    puts "Building Atom feed file #{GoogleMerchant::configuration.path}..."
    
    feed_file = File.new("public/#{GoogleMerchant::configuration.path}", 'w')
    feed_file.puts(action_view.render(:template => "google_merchant/application/show"))
    feed_file.close
    
    puts "Atom feed file was built successfully!"
  end
end