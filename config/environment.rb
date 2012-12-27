# Load the rails application
require File.expand_path('../application', __FILE__)

# Configure some environment variables
ENV['TWITTER_CONSUMER_KEY'] = "8SkmzreF01lWj1Q5FI2lRw"
ENV['TWITTER_CONSUMER_SECRET'] = "xkpYoN368ZghxBqda2vDtKaHYhU8gPSoHUPDbUnFU0"

# Initialize the rails application
WhatdididrinkApi::Application.initialize!
