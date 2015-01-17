require 'socket'      # Sockets are in standard library
require 'uri'
		
$host = ARGV[0]
$port = ARGV[1]
$path = ARGV[2]
$method = ARGV[3]
$action = ARGV[4]
$value = ARGV[5]
$data = ARGV[6]

if  ARGV.length >= 3
	puts $host
	puts $port
	puts $path
	puts $method
	puts $action
	puts $value
	puts $data
	socket = TCPSocket.open($host,$port)  	# Connect to server

	if $data != nil
		if $data.include?(" ")
			dat = $data.split.join('%20')
			puts dat
		else
			dat = $data
		end
		request = "http://"+$host+":"+$port+$method +"?acao="+$action+"&value="+$value+"&dado="+dat
	else
		request = "http://"+$host+":"+$port+$method +"?acao="+$action+"&value="+$value
	end

	socket.print(request)
	puts "Mensagem enviada\n"
	response = socket.read              	# Read complete response
	puts "Leu resposta\n"
	headers, body = response.split("\r\n\r\n", 2)
	print headers
	print "\n\n"
	print body                 	# And display it

else
  print "Nope. Try again \n"
end
