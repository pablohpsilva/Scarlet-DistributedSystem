require 'socket'
require 'uri'
require 'timeout'
load '../Kernel/Server.class.rb'

$host = ARGV[0]
$port = ARGV[1]

@server_instance = Server.new($port)

def main
  server = TCPServer.new( $host, $port )
  puts "Scarlet server is running...\nPORT = "+$port+"\nHOST = "+$host

  loop do
    Thread.start(server.accept) do |client|
      puts client
      #puts client.inspect
      #request = client.read
      request = client.recv( 100000 )
      #request = client.readpartial(1000)
      #request = client.gets
      #request = client.recvfrom(100)
      puts request
      @server_instance.start(client,request)
    end
  end
end

main