require 'json'

require 'dotenv'

Dotenv.load

require 'unirest'

def get_string_to_test
   print "Enter Text:"
   gets.chomp 
end

while(str =get_string_to_test)
   puts "Checking #{str}"

   response = Unirest.post "https://gateway-a.watsonplatform.net/calls/text/TextGetEmotion", 
	                        headers:{ "Accept" => "application/json" }, 
	                        parameters:{ 
	                        	:apikey => ENV['ALCHEMY_API_KEY'], 
	                        	:outputMode => "json",
	                        	:text => str 
		                        }

   emotions = response.body["docEmotions"].map do |key, value|
   	[key.to_sym, value.to_f]
   end

   
   topic, rating = emotions.inject do |memo, pair|
       pair[1] > memo[1] ? pair : memo
   end

   puts "Mostly #{topic} (#{'%.0f' % (rating * 100)}%)"
end

