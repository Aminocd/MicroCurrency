FactoryBot.define do
  factory :attempted_linkage do
    user 
    currency_id_external_key { 10 }

=begin
    after(:build) do | al |
      class << attempted_linkage
# don't need these method re-assignemnts anymore as I am using FakeWeb to get dummy data returned by HTTP requests
        def ensure_currency_exists_and_is_active; true; end
        def get_currency_attributes(currency_id)
          case currency_id
          when 1
            response = '{"data":{"id":"1","type":"currencies","attributes":{"issuer-id":3,"issuer-user-id":3,"issuer-user-name":"Kian","issuer-user-avatar-url":"/system/users/avatars/000/000/003/original/avatar.jpg?1568607042","issuer-public-currency-holding-id":1,"burn-rate":0,"daily-burn-rate":"0.0","store-count":0,"listing-count":0,"product-count":0,"name":"Kian Dollar","description":"The first currency created on MyCurrency\n! Check the creation date.","created-at":"2019-09-15T21:14:17.830-07:00","updated-at":"2019-09-16T19:38:19.756-07:00","get-icon-url":"/system/currencies/icons/000/000/001/original/currency.jpg?1568607257","number-of-reviews":0,"average-score":null,"user-is-active":true}}}'
          when 2
            response = '{"data":{"id":"2","type":"currencies","attributes":{"issuer-id":2,"issuer-user-id":2,"issuer-user-name":"Amin","issuer-user-avatar-url":"/system/users/avatars/000/000/002/original/avatar.jpg?1568543223","issuer-public-currency-holding-id":2,"burn-rate":700,"daily-burn-rate":"0.000198805","store-count":1,"listing-count":0,"product-count":1,"name":"Amin Credit","description":"one dollars worth of credit for purchases from my store","created-at":"2019-09-15T21:45:53.821-07:00","updated-at":"2020-03-15T01:41:03.937-07:00","get-icon-url":"/system/currencies/icons/000/000/002/original/currency.jpg?1584261663","number-of-reviews":0,"average-score":null,"user-is-active":true}}}'
          when 3
            response = '{"data":{"id":"3","type":"currencies","attributes":{"issuer-id":4,"issuer-user-id":4,"issuer-user-name":"Don","issuer-user-avatar-url":"/system/users/avatars/000/000/004/original/avatar.jpg?1568616946","issuer-public-currency-holding-id":3,"burn-rate":500,"daily-burn-rate":"0.00014052","store-count":1,"listing-count":0,"product-count":1,"name":"CryptoStore Dollars","description":"store credit for my crypto asset store","created-at":"2019-09-15T23:59:22.636-07:00","updated-at":"2019-09-15T23:59:22.636-07:00","get-icon-url":"/system/currencies/icons/000/000/003/original/currency.jpg?1568617162","number-of-reviews":0,"average-score":null,"user-is-active":true}}}'
          else
            response = '{"data":{"id":"4","type":"currencies","attributes":{"issuer-id":3,"issuer-user-id":3,"issuer-user-name":"Kian","issuer-user-avatar-url":"/system/users/avatars/000/000/003/original/avatar.jpg?1568607042","issuer-public-currency-holding-id":7,"burn-rate":0,"daily-burn-rate":"0.0","store-count":0,"listing-count":0,"product-count":0,"name":"USD Tracker","description":"Is worth exactly $1 USD","created-at":"2019-09-16T19:43:22.229-07:00","updated-at":"2019-09-16T19:43:22.229-07:00","get-icon-url":"/system/currencies/icons/000/000/004/original/currency.jpg?1568688202","number-of-reviews":0,"average-score":null,"user-is-active":true}}}'
          end

          response_json = JSON.parse(response)
          response_json["data"]["attributes"] 
        end 
#      al.stub(:get_currency_attributes).with(currency_id) do
#      end
      end
    end
=end
  end
end
