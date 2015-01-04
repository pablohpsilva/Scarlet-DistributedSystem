require 'socket'
require 'uri'
load '../Kernel/Server.class.rb'

@server_instance = Server.new(8888)

def main
  server = TCPServer.new( 'localhost', 8888 )
  puts 'Scarlet server is running...'

  loop do
    Thread.start(server.accept) do |client|
      @server_instance.start(client)
    end
  end
end

main