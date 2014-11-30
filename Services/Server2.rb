require 'socket'
require 'cgi'
require 'uri'
require 'json'
load 'Kernel/ServerStrings.rb'
load 'Kernel/ServerForger.class.rb'
load 'Kernel/Server.class.rb'

@server_configs
@server_strings = ServerStrings.new()
@server_instance = Server.new()

def main
  server = TCPServer.new( @server_configs.get_server['domain'], @server_configs.get_server['port'] )

  puts 'Scarlet server is running...'

  loop do

    #Server will accept a request
    Thread.start(server.accept) do |client|
      @server_instance.start(client)
    end
  end
end

=begin
  The magic starts right here. Scarlet welcomes you
=end
if !(ARGV.length < 1) && !(ARGV.length > 2)
  if ARGV[0].split('.')[1] == 'json'
    #@server_configs = ServerForger.new( ARGV[0] ) #from the Server class
    @server_instance = Server.new(ARGV[0])
    main
  elsif ARGV.length == 2
    #server_configs = ServerForger.new( ARGV[0], ARGV[1] )  #from the Server class
    @server_instance = Server.new(ARGV[0], ARGV[1])
    main
  else
    @server_strings.using_scarlet #from ServerString.rb
  end
else
  @server_strings.using_scarlet #from ServerString.rb
end
