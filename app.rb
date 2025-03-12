require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  @raw_response = HTTP.get("api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"")

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)
 
  @currencies = @parsed_response.fetch ("currencies")
  
  erb (:homepage)
end

get("/:first_symbol") do
  @the_symbol = params.fetch("first_symbol") 

  erb(:step_one)

end
BASE_URL = "https://api.exchangerate.host/latest"

def fetch_currency_data
  response = HTTParty.get(BASE_URL)
  response.parsed_response["rates"] if response.code == 200
end

get '/:currency' do
  @currency = params[:currency].upcase
  @rates = fetch_currency_data
  halt 404, "Currency not found" unless @rates&.key?(@currency)
  erb :currency
end

get '/:from/:to' do
  @from = params[:from].upcase
  @to = params[:to].upcase
  @rates = fetch_currency_data
  halt 404, "Currency not found" unless @rates&.key?(@from) && @rates.key?(@to)
  @exchange_rate = (@rates[@to] / @rates[@from]).round(6)
  erb :exchange
end
