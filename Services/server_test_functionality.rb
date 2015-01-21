require 'socket'
require 'uri'
load '../Kernel/Server.class.rb'

@server_instance = Server.new(8889)

def main
  server = TCPServer.new( 'localhost', 8889 )
  puts 'Scarlet server is running...'

  loop do
    Thread.start(server.accept) do |client|
      puts client.inspect
      puts 'aqui'
      request = client.read
      puts request
      @server_instance.start(client,request)
    end
  end
end

main