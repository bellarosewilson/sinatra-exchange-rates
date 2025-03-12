require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch{"("EXCHANGE_RATE_KEY")}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)
 
  @currencies = @parsed_response.fetch ("currencies")
  
  erb (:homepage)
end

get("/:from_currency") do
  @the_symbol = params.fetch("first_symbol") 
 
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)
 
  @currencies = @parsed_response.fetch ("currencies")
  erb(:step_one)

get("/:from_currency/:to_currency") do
  @from_currency = params.fetch("from_currency")
  @to_currency = params.fetch("to_currency")

  @raw_response = HTTP.get("https://api.exchangerate.host/convert?from=#{@first_symbol}&to=#{@second_symbol}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)

  @conversion = @parsed_response.fetch("result")
  erb(:step_two)

end
