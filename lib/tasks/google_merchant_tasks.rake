namespace :google_merchant do
  desc "Generates Google Merchant feed file"
  
  
  task generate: :environment do
   
    include Rails.application.routes.url_helpers # brings ActionDispatch::Routing::UrlFor
    include ActionView::Helpers::TagHelper

    action_view = ActionView::Base.new(GoogleMerchant::Engine.path_to_views)
  
    action_view.assign({
      :configuration => GoogleMerchant::configuration
    })
  
    #f = File.new(file_name, 'w')
    puts(action_view.render(:template => "google_merchant/feed/index"))
    #f.close
  

=begin    
    controller = ApplicationController.new
    #controller.request = 
    controller.render_to_string(
  :template => 'google_merchant/feed/index',
  :locals => { :@configuration => GoogleMerchant::configuration }
)
=end
  end

end