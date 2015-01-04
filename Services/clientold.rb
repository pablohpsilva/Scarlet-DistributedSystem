require 'socket'      # Sockets are in standard library


#if ARGV.length == 3
  host = ARGV[0] = 'localhost'
  port = ARGV[1] = 8888
  path = ARGV[2] = 'index.html'

  # This is the HTTP request we send to fetch a file
  request = "GET #{path} HTTP/1.0\r\n\r\n"

  socket = TCPSocket.open(host,port)  # Connect to server
  socket.print(request)               # Send request
  response = socket.read              # Read complete response
  # Split response at first blank line into headers and body
  headers, body = response.split("\r\n\r\n", 2)
  print body                          # And display it
  print "\n\n"
  print headers
# else
#   print "Nope. Try again \n"
# end