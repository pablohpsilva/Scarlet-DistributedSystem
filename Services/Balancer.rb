require 'socket'
require 'cgi'
require 'uri'
require 'securerandom'
require 'digest'
load '../Kernel/Server.class.rb'
load '../Services/DatabaseManager.rb'

remote_host = 'localhost'
remote_port = 8888
listen_port = 8081
max_threads = 5
threads = []
database_manager = DatabaseManager.new

puts 'starting server'
server = TCPServer.new(nil, listen_port)

  while true
    # Start a new thread for every client connection.
    puts 'waiting for connections'
    threads << Thread.new(server.accept) do |client_socket|
      begin
        puts "#{Thread.current}: got a client connection"
        begin
          # client_aux = client_socket.dup
          # client_aux = client_socket.dup
          reading = client_socket.recv( 100 )
          # reading = client_socket.gets
          u = URI.parse(reading.split(' ')[1])
          values = CGI.parse(u.query).values
          remote = database_manager.find_user_data( Digest::MD5.hexdigest(values[0][0]) )
          remote_host = remote[0]
          remote_port = remote[1]
          server_socket = TCPSocket.new(remote_host, remote_port)
          server_socket.puts reading
        rescue Errno::ECONNREFUSED
          client_socket.close
          raise
        end
        puts "#{Thread.current}: connected to server at #{remote_host}:#{remote_port}"

        while true
          # Wait for data to be available on either socket.
          (ready_sockets, dummy, dummy) = IO.select([client_socket, server_socket])
          begin
            ready_sockets.each do |socket|
              data = socket.readpartial(10000)
              puts "socket = #{socket}\n\nclient_socket = #{client_socket}\n\n"
              if socket == client_socket
                # Read from client, write to server.
                puts "#{Thread.current}: client->server #{data.inspect}"
                server_socket.write data
                server_socket.flush
              else
                # Read from server, write to client.
                puts "#{Thread.current}: server->client #{data.inspect}"
                client_socket.write data
                client_socket.flush
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
      client_socket.close rescue StandardError
      server_socket.close rescue StandardError
    end
    # Clean up the dead threads, and wait until we have available threads.
    puts "#{threads.size} threads running"
    threads = threads.select { |t| t.alive? ? true : (t.join; false) }
    while threads.size >= max_threads
      sleep 1
      threads = threads.select { |t| t.alive? ? true : (t.join; false) }
    end
  end