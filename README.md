# GoogleMerchant

> **In development**

Provides functionality for Google Merchant feed generation in **.atom** format. Additionally allows to create a model for Google Products Categories using **Awesome Nested Set gem** and build categories tree from remote plain text file provided by Google.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_admin-awesome_nested_set-dependent_selection', git: 'git://github.com/udovenko/google_merchant.git'
```

And then execute:

    $ bundle install
    $ rails generate google_merchant:install
    
Last command will copy initializer template and mount gem engine routes to your application.

## Usage

This gem can be used for two purposes: **Google Merchant feed generation** and **Google Product Categories tree building**. Each part of functionality is optional but it's advisable to use them together.

## Configuration

Check **initializers/google_merchant.rb** after gem installation to see the configuration example. Since the gem was created for custom shops without any e-commerce solutions like **Spree**, mapping products to feed view is just an array generation within a proc., so you can manage feed tags content absolutely without restrictions. 

## Feed

By default, feed is available on demand as a controller action by route **google_merchant/feed.atom**. This means it will be always generated again for each request, which could be expensive for a big amount of products. In this case consider feed file generation.

To generate feed file according to relative path and format given in configuration, execute: 

    $ rake google_merchant:feed:generate
    
You can use **Whenever gem** to schedule feed generation as frequently as required:

    every 1.day, :at => '5:00 am' do
      rake 'google_merchant:feed:generate'
    end 

## Categories tree
Building **Google Product Categories** tree requires additional table in your application DB and **Awesome Nested Set gem**.
To create categories table copy migration from gem and migrate your schema:

    $ rake google_merchant:install:migrations 
    $ rake db:migrate
    
This will create **google_merchant_categories** table. It's empty and requires to be populated with data. To do so run **update** task:

    $ rake google_merchant:categories:update
    
It will take some time. Be sure that you set up proper **taxonomy_file_url** in the configuration. By default **en-US** taxonomy is used.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_admin-awesome_nested_set-dependent_selection/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
