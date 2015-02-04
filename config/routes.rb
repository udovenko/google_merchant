GoogleMerchant::Engine.routes.draw do
  get 'feed(.:format)', to: "application#feed"
end
