# Google Merchant feed and categories configuration for gem "google_merchant".
# See https://support.google.com/merchants/answer/160593 for details.
GoogleMerchant.configure do |config|
    
  config.taxonomy_file_url = "http://www.google.com/basepages/producttype/taxonomy.en-US.txt"
  config.path = "/google_merchant.atom"
  config.language = "en-US"
  config.host = "your-site.com"
  config.protocol = "http"
  config.feed_title = "YourSite products"
  config.feed_updated = Proc.new { Time.zone.now }
  
  # Not a part of configuration, just used in example:
  shop_url = "#{config.protocol}://#{config.host}"
  
  # Products list. Should be generated programmatically of course, with content like:
  config.entries = Proc.new do
    [
      {
        id: 'TV_123456',
        title: 'LG 22LB4510 - 22" LED TV - 1080p (FullHD)',
        description: 'Attractively styled and boasting stunning picture quality,
          the LG 22LB4510 - 22" LED TV - 1080p (FullHD) is an excellent 
          television/monitor. The LG 22LB4510 - 22" LED TV - 1080p (FullHD) 
          sports a widescreen 1080p panel, perfect for watching movies in their 
          original format, whilst also providing plenty of working space for 
          your other applications.',
        link: "#{shop_url}/electronics/tv/22LB4510.html",
        image_link: 'http://images.example.com/TV_123456.png',
        condition: 'used',
        availability: stock,
        price: '159.00 USD',
        brand: 'LG',
        mpn: '22LB4510/US',
        
        # Here you can use categories tree model to assign Google Product Category to your product: 
        google_product_category: 'Electronics > Video > Televisions > Flat Panel Televisions',
        product_types: [
          'Consumer Electronics > TVs > Flat Panel TVs',
          # ...there can as many product types as you need 
        ]
      },
      #...and all your other products
    ]
  end
end