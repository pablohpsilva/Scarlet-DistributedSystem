require 'socket'
load 'Kernel/ServerStrings.rb'
load 'Kernel/ServerForger.class.rb'
load 'Kernel/Server.class.rb'

@server_configs = nil
#@server_strings = nil
@server_instance = nil

class Server_Instance

  def initialize_server(folder_json, port = nil)
    #@server_strings = ServerStrings.new
    @server_instance = Server.new(folder_json, port)
    #@server_configs = @server_instance.get_server_configs
  end

  def initialize(folder_json, port = nil)
    initialize_server(folder_json, port)
    server = TCPServer.new( @server_instance.get_server_configs.get_server['domain'], @server_instance.get_server_configs.get_server['port'] )
    puts "Scarlet server #{@server_instance.get_name} is running..."

    loop do
      #Server will accept a request
      Thread.start(server.accept) do |client|
        @server_instance.start(client)
        client.close
      end
    end

  end

end