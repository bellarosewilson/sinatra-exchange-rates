# /env_test.rb
require "dotenv/load"

pp ENV.fetch("GMAPS_KEY")
pp ENV.fetch("OPENAI_KEY")
pp ENV.fetch("EXCHANGE_RATE_KEY")
