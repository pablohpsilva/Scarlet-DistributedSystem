load 'Server.class.rb'
load '../Kernel/LoadList.class.rb'

class LoadBalancerProxy

  private
    @servers_list
    @max_connections_per_server

  public
    def initialize(max_connections_per_server = nil)
      @max_connections_per_server = max_connections_per_server if (max_connections_per_server != nil)
      @servers_list = Array.new
    end

    def register_server(instance_or_name, folder_or_json = nil, port = nil)
      if (instance_or_name.instance_of?(Server))
        @servers_list << LoadList.new(instance_or_name, @max_connections_per_server)
      else
        @servers_list << LoadList.new(Server.new(instance_or_name, folder_or_json, port), @max_connections_per_server)
      end
=begin
      @servers_list << (instance_or_name.instance_of?(Server)) ?
          LoadList.new(instance_or_name, @max_connections_per_server) :
          LoadList.new(Server.new(instance_or_name, folder_or_json, port), @max_connections_per_server)
=end
    end

    def get_server
      (0 .. @servers_list.size).each do |index|
        return @servers_list[index] if (@servers_list[index].get_counter != @max_connections_per_server)
      end
      return nil
    end

end