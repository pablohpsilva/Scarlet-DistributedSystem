load 'Services/ServerInstance.rb'
=begin
load 'Services/Server.class.rb'

def main
  server = TCPServer.new( 'localhost', 8888 )

  puts 'Scarlet load balancer is running...'

  server1 = Server.new('albert','./Services/conf.json')
  loop do
    #Server will accept a request
    Thread.start(server.accept) do |client|
      response = server1.start_server(client)
      client.print "\r\n#{response['response']}\r\n"
      if ( response['message'] != nil )
        client.print response['message']
      end

      client.close
    end
  end
end

main
=end

puts 'Started...\n'
2.times do |i|
  Thread.new {
    puts "server #{i}"
    Server_Instance.new('app/',8888+i)
  }
end

gets