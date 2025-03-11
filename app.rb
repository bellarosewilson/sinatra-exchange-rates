require 'sinatra'
require 'httparty'
require 'nokogiri'

BASE_URL = "https://api.exchangerate.host/latest"

def fetch_currency_data
  response = HTTParty.get(BASE_URL)
  response.parsed_response["rates"] if response.code == 200
end

get '/' do
  @rates = fetch_currency_data
  halt 500, "Error fetching currency data" unless @rates
  erb :index
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
