root_url = "#{@configuration.protocol}://#{@configuration.host}"
atom_feed \
  'xmlns:g' => 'http://base.google.com/ns/1.0', 
  language: @configuration.language,
  id: "tag:#{@configuration.host},2005:#{@configuration.path}",
  root_url: root_url,
  url: "#{root_url}#{@configuration.path}" do
  
  xml.title @configuration.feed_title
  xml.updated @configuration.feed_updated.call.strftime("%Y-%m-%dT%H:%M:%SZ")
  
  @configuration.entries.call.each do |entry|
    xml << render(partial: 'google_merchant/application/show/entry', locals: {entry: entry})
  end
end