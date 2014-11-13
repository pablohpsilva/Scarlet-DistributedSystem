load 'Services/Server.class.rb'

#server1 = Server.new('albert','./Services/conf.json')
#server2 = Server.new('bruce','localhost','6666')

def main
  server = TCPServer.new( 'localhost', 8888 )

  puts 'Scarlet load balancer is running...'

  server1 = Server.new('albert','./Services/conf.json')
  loop do
    #Server will accept a request
    Thread.start(server.accept) do |client|
      response = server1.start_server(client)
      client.print response['response']
      client.print response['message']
      client.close
    end
  end
end

main