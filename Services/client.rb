require 'socket'      # Sockets are in standard library
require 'net/http'
require 'uri'
		
$host = ARGV[0]
$port = ARGV[1]
$path = ARGV[2]
$method = ARGV[3]

if ARGV.length >= 3 && ARGV.length < 5
	# This is the HTTP request we send to fetch a file	
	request = "GET #{$path} HTTP/1.0\r\n\r\n"

	puts "\n\n"
	socket = TCPSocket.open($host,$port)  	# Connect to server
	socket.print(request)               	# Send request
	response = socket.read              	# Read complete response
	# Split response at first blank line into headers and body
	headers, body = response.split("\r\n\r\n", 2)
	print body                 	# And display it
	print "\n\n"
	print headers
	
	if $method.eql?('usePost') && (response.include? "HTTP/1.1 200 OK")
		puts "\n\nmethod: #{$method}\n\n"

		puts "Variavel:"
		var = $stdin.gets.chomp
		
		puts "\n\nValor:"
		val = $stdin.gets.chomp
		puts "Variavel = " + var + "\nValor = " + val + "."
		
		uri = URI('localhost')
		puts "\n\nURI = #{uri}\n"
		#response = Net::HTTP.post_form(uri, {"q" => "My query", "per_page" => "50"})
		
		http = Net::HTTP.new($host, $port)
	
		params = {foo: var}
		request = Net::HTTP::Post.new($path)
		request.set_form_data(params)
		
		response = http.request(request)
		puts "request = #{request}"
		puts "response = #{response}"
		puts "response.body = #{response.body}"
		
	end
else
  print "Nope. Try again \n"
end