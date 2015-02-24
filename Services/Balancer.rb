require 'socket'
require 'cgi'
require 'uri'
require 'securerandom'
require 'digest'
require 'timeout'
load '../Kernel/Server.class.rb'
load '../Services/DatabaseManager.rb'

remote_host = 'localhost'
$port = ARGV[0]
#$port = 8889
threads = []
# max_threads = 5
database_manager = DatabaseManager.new
@server_instance = Server.new($port)

puts 'starting server'
server = TCPServer.new(nil, $port)

  while true
    # Start a new thread for every client connection.
    puts 'waiting for connections'
    threads << Thread.new(server.accept) do |client|
      begin
        puts "#{Thread.current}: got a client connection"
        begin
          request = client.recv( 1000 )
          puts Thread.current
          if !request.eql?('')
            r = request.split
            values = CGI.parse(r[1]).values
            remote = database_manager.find_user_data( Digest::MD5.hexdigest(values[0][0]) )
            remote_host = remote[0]
            remote_port = remote[1]
            port = $port
            if remote_port.to_s == port.to_s
              @server_instance.start(client,request)
              client.puts request
            else
              # @server_instance.start(client,request)
              # puts "Server_Instance #{@server_instance}"
              server_socket = TCPSocket.new(remote_host, remote_port)
              server_socket.puts request
            end

          else
            puts Thread.current
            Thread.kill(Thread.current)
          end
        rescue Errno::ECONNREFUSED
          client.close
          raise
        end
        puts "#{Thread.current}: connected to server at #{remote_host}:#{remote_port}"

        while true
          # Wait for data to be available on either socket.
          (ready_sockets, dummy, dummy) = IO.select([client, server_socket])
          begin
            ready_sockets.each do |socket|
              data = socket.readpartial(10000)
              puts "socket = #{socket}\n\nclient = #{client}\n\n"
              if socket == client
                # Read from client, write to server.
                puts "#{Thread.current}: client->server #{data.inspect}"
                server_socket.write data
                server_socket.flush
              else
                # Read from server, write to client.
                puts "#{Thread.current}: server->client #{data.inspect}"
                client.write data
                client.flush
              end
            end
          rescue EOFError
            break
          end
        end
      rescue StandardError => e
        puts "Thread #{Thread.current} got exception #{e.inspect}"
      end
      puts "#{Thread.current}: closing the connections"
      client.close rescue StandardError
      server_socket.close rescue StandardError
    end
    # Clean up the dead threads, and wait until we have available threads.
    puts "#{threads.size} threads running"
    threads = threads.select { |t| t.alive? ? true : (t.join; false) }
    while threads.size >= 1
      sleep 1
      threads = threads.select { |t| t.alive? ? true : (t.join; false) }
    end
  end