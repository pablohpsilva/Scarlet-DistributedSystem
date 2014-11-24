load 'LoadBalancerProxy.class.rb'

MAX_CONN = 1
MAX_INSTANCES = 4
@lbp = LoadBalancerProxy.new(MAX_CONN)

def register_random_servers
  (0..MAX_INSTANCES).each do |i|
    @lbp.register_server( "server#{i}", '../app/', 8889+i)
  end
end

def main
  server = TCPServer.new( 'localhost', 8888 )

  register_random_servers

  puts 'Scarlet load balancer is running...'

  loop do
    Thread.start(server.accept) do |client|
      auxServer = @lbp.get_server.get_instance
      #print auxServer.inspect
      print "Server in use: #{auxServer.get_name}"
      response = auxServer.start(client)
      client.print "\r\n#{response['response']}\r\n"
      if ( response['message'] != nil )
        client.print response['message']
      end
      client.close
    end
  end

end

main