require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  @currencies = JSON.parse(response.to_s).fetch("currencies")

  erb(:homepage)
end

get("/:from_currency") do
  @the_symbol = params.fetch("from_currency")

  response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  @currencies = JSON.parse(response.to_s).fetch("currencies")

  erb(:step_one)
end

get("/:from_currency/:to_currency") do
  @from = params.fetch("from_currency")
  @to = params.fetch("to_currency")

  url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@from}&to=#{@to}&amount=1"
  response = HTTP.get(url)
  @amount = JSON.parse(response.to_s).fetch("result")

  erb(:step_two)
end
