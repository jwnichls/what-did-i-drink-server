Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, :fields => [:email]
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
  provider :foursquare, ENV['FOURSQUARE_APP_ID'], ENV['FOURSQUARE_APP_SECRET']
  # TODO: Identity and Facebook
end