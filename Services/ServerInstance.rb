require 'socket'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'
load '../Kernel/Server.class.rb'

@server_instance = nil

class Server_Instance

  private
    def initialize_server(port = nil)
      @server_instance = Server.new(port)
    end

  public
    def initialize(port = nil)
      puts "Foi\n"
      initialize_server(port)
      server = TCPServer.new( @server_instance.get_server_configs.get_server['domain'], @server_instance.get_server_configs.get_server['port'] )
      puts "Scarlet server #{@server_instance.get_name} is running on port #{@server_instance.get_server_configs[]}..."

      loop do
        #Server will accept a request
        Thread.start(server.accept) do |client|
          @server_instance.start(client)
          client.close
        end
      end

    end

end