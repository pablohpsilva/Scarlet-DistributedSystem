require 'socket'
require 'uri'
load './ServerInstance.rb'

@remote_ports = (8888..8889).to_a
@remote_host = 'localhost'
#@remote_port = 8888
@load_balancer_listener = nil
@load_balancer_listener_port = 8080
@max_threads = 5
@threads = []
@servers = []
@interval = '0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z'.split(',')

@distributed_servers = nil




@counter = 0

def load_servers
  @remote_ports.length.times do |i|
    Thread.new {
      puts "server running #{i} on port #{@remote_ports[i]}"
      @servers << Server_Instance.new(@remote_ports[i])
    }
  end
end


def init
  load_servers
  puts 'Default servers are up and running'
  puts "# Default servers: #{@remote_ports.length}"
  @load_balancer_listener = TCPServer.new(@remote_host, @load_balancer_listener_port)
  puts 'Load Balancer is up and running...'
  start
end

def start
  puts 'hello'
  while true
    puts 'waiting for connections'
    @threads << Thread.new(@load_balancer_listener.accept) do |client_socket|
      begin
        #server_socket = TCPSocket.new(@remote_host, 8888)
        @servers[0].start(client_socket)
      rescue StandardError => e
        puts "Thread #{Thread.current} got exception #{e.inspect}"
      end
      puts "#{Thread.current}: closing the connections"
      client_socket.close rescue StandardError
      #server_socket.close rescue StandardError
      puts "in use: #{@counter}"
      @counter += 1;
    end

  end
end

init

# while true
#   # Start a new thread for every client connection.
#   puts 'waiting for connections'
#   threads << Thread.new(server.accept) do |client_socket|
#     begin
#       # puts "#{Thread.current}: got a client connection"
#       # begin
#       #   server_socket = TCPSocket.new(remote_host, remote_port)
#       # rescue Errno::ECONNREFUSED
#       #   client_socket.close
#       #   raise
#       # end
#       # puts "#{Thread.current}: connected to server at #{remote_host}:#{remote_port}"
#       #
#       # while true
#       #   # Wait for data to be available on either socket.
#       #   (ready_sockets, dummy, dummy) = IO.select([client_socket, server_socket])
#       #   begin
#       #     ready_sockets.each do |socket|
#       #       data = socket.readpartial(10000)
#       #       puts "socket = #{socket}\n\nclient_socket = #{client_socket}\n\n"
#       #       if socket == client_socket
#       #         # Read from client, write to server.
#       #         puts "#{Thread.current}: client->server #{data.inspect}"
#       #         server_socket.write data
#       #         server_socket.flush
#       #       else
#       #         # Read from server, write to client.
#       #         puts "#{Thread.current}: server->client #{data.inspect}"
#       #         client_socket.write data
#       #         client_socket.flush
#       #       end
#       #     end
#       #   rescue EOFError
#       #     break
#       #   end
#       # end
#     rescue StandardError => e
#       puts "Thread #{Thread.current} got exception #{e.inspect}"
#     end
#     puts "#{Thread.current}: closing the connections"
#     client_socket.close rescue StandardError
#     server_socket.close rescue StandardError
#   end
#   # # Clean up the dead threads, and wait until we have available threads.
#   # puts "#{threads.size} threads running"
#   # threads = threads.select { |t| t.alive? ? true : (t.join; false) }
#   # while threads.size >= max_threads
#   #   sleep 1
#   #   threads = threads.select { |t| t.alive? ? true : (t.join; false) }
#   # end
# end