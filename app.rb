require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)
 
  @currencies = @parsed_response.fetch("currencies")
  
  erb(:homepage)
end

get("/:from_currency") do
  @the_symbol = params.fetch("from_currency") 
 
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)
 
  @currencies = @parsed_response.fetch("currencies")
 
  erb(:step_one)
end

get("/:from_currency/:to_currency") do
  @from = params.fetch("from_currency")
  @to = params.fetch("to_currency")

  @url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@from}&to=#{@to}&amount=1"

  @raw_response = HTTP.get(@url)

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)

  @amount = @parsed_response.fetch("result")
  
  erb(:step_two)
end
