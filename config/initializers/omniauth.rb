Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
  provider :foursquare, ENV['FOURSQUARE_APP_ID'], ENV['FOURSQUARE_APP_SECRET']
  provider :identity, :fields => [:email], on_failed_registration: lambda { |env|    
    IdentitiesController.action(:new).call(env)
  }
  # TODO: Facebook
end