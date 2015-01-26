Rails.application.routes.draw do

  mount GoogleMerchant::Engine => "/google_merchant"
end
