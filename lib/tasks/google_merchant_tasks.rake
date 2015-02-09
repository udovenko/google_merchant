namespace :google_merchant do
  namespace :categories do
    desc "Tasks for Google Product Categories tree model"

    # Updates categories tree from Google product categories remote file.
    task update: :environment do
      GoogleMerchant::Category.verbose = true
      GoogleMerchant::Category.update
    end
  end
  
  namespace :feed do
    desc "Tasks for Google Merchant feed"
    
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

      puts "Building feed file #{GoogleMerchant::configuration.feed_path}.#{GoogleMerchant::configuration.feed_format}..."

      feed_file = File.new("public/#{GoogleMerchant::configuration.feed_path}.#{GoogleMerchant::configuration.feed_format}", 'w')
      feed_file.puts(action_view.render(template: "google_merchant/application/feed.#{GoogleMerchant::configuration.feed_format}"))
      feed_file.close

      puts "Atom feed file was built successfully!"
    end
  end
end