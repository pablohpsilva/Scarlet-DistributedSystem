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
	
elsif ARGV.length > 3
	socket = TCPSocket.open($host,$port)  	# Connect to server
	if $data != nil
		request = "http://"+$host+":8888"+$method +"?acao="+$action+"&value="+$value+"&dado="+$data
	else
		request = "http://"+$host+":8888"+$method +"?acao="+$action+"&value="+$value
	end

	socket.print("POST #{request} HTTP/1.0\r\n\r\n")

	response = socket.read              	# Read complete response
	headers, body = response.split("\r\n\r\n", 2)
	print body                 	# And display it
	print "\n\n"
	print headers		
		
else
  print "Nope. Try again \n"
end
