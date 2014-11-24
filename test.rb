load 'Services/Server.class.rb'

def main
  server = TCPServer.new( 'localhost', 8888 )

  puts 'Scarlet load balancer is running...'

  server1 = Server.new('albert','./Services/conf.json')
  loop do
    #Server will accept a request
    Thread.start(server.accept) do |client|
      response = server1.start(client)
      client.print "\r\n#{response['response']}\r\n"
      if ( response['message'] != nil )
        client.print response['message']
      end

      client.close
    end
  end
end

main