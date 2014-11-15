require 'socket'      # Sockets are in standard library
require 'net/http'
require 'uri'
		
$host = ARGV[0]
$port = ARGV[1]
$path = ARGV[2]
$method = ARGV[3]
$action = ARGV[4]
$value = ARGV[5]
$data = ARGV[6]

if ARGV.length >= 3
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
	
	if ARGV.length > 3
		puts "\n\nmethod: #{$method}\n\n"
		
		uri = URI('localhost')
		puts "\n\nURI = #{uri}\n"
		if $data != nil
			t = "http://"+$host+$method +"?acao="+$action+"&value="+$value+"&dado="+$data
		else
			t = "http://"+$host+$method +"?acao="+$action+"&value="+$value
		end
		http = Net::HTTP.new($host, $port) # Abre um conexão HTTP com o servidor
		#req = Net::HTTP::Post.new($method) # Faz uma requisição para um arquivo		
		req = Net::HTTP::Post.new(t) # Faz uma requisição para um arquivo		
		req.set_form_data("acao" => $action, "nome" => $value)		
		response = http.request(req)		
		
		puts "req = #{req}"
		puts "response = #{response}"
		puts "response.body = #{response.body}"		
		
	end
		
else
  print "Nope. Try again \n"
end