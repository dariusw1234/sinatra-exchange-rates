require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

exchange_api_key = ENV.fetch("EXC_API_KEY")

get("/") do
  @list_url = "https://api.exchangerate.host/list?access_key=#{exchange_api_key}"
  @currencies = HTTP.get(@list_url).to_s
  @parsed_currencies = JSON.parse(@currencies)
  @currencies_hash = @parsed_currencies.fetch("currencies")

  @list_of_currencies = @currencies_hash.keys
  erb(:currency_pairs)
end

get("/:from_currency") do
  @list_url = "https://api.exchangerate.host/list?access_key=#{exchange_api_key}"
  @currencies = HTTP.get(@list_url).to_s
  @parsed_currencies = JSON.parse(@currencies)
  @currencies_hash = @parsed_currencies.fetch("currencies")

  @original_currency = params.fetch("from_currency")
  @list_of_currencies = @currencies_hash.keys
  erb(:convert)
end

get("/:from_currency/:to_currency") do
  @list_url = "https://api.exchangerate.host/list?access_key=#{exchange_api_key}"
  @currencies = HTTP.get(@list_url).to_s
  @parsed_currencies = JSON.parse(@currencies)
  @currencies_hash = @parsed_currencies.fetch("currencies")
  
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")
  @list_of_currencies = @currencies_hash.keys

  @convert_url = "https://api.exchangerate.host/convert?from=#{@original_currency}&to=#{@destination_currency}&amount=1&access_key=#{exchange_api_key}"
  @converts = HTTP.get(@convert_url)
  @parsed_convert = JSON.parse(@converts)
  @result = @parsed_convert.fetch("result")
  erb(:convert_to)
end
