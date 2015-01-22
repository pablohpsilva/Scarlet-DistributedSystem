require 'socket'
require 'uri'
require 'timeout'
load '../Kernel/Server.class.rb'

@server_instance = Server.new(8889)

def main
  server = TCPServer.new( 'localhost', 8889 )
  puts 'Scarlet server is running...'

  loop do
    Thread.start(server.accept) do |client|
      puts "Carai de asa\n"
      puts client
      #puts client.inspect
      request = client.read
      #request = client.recv( 100000 )
      #request = client.readpartial(1000)
      #request = client.gets.chomp
      #request = client.recvfrom(100)
      puts request
      @server_instance.start(client,request)
    end
  end
end

main