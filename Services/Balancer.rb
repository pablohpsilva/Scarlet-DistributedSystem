require 'socket'
require 'cgi'
require 'uri'
require 'securerandom'
require 'digest'
require 'timeout'
load '../yora/lib/yora.rb'

remote_host = 'localhost'
$port = ARGV[0]
@node_ports = ARGV[1].split(',')
#$port = 8889
threads = []
# max_threads = 5
# database_manager = DatabaseManager.new
# @server_instance = Server.new($port)
@random = Random.new

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
          port_chosen = @random.rand(0..(@node_ports.length-1))
          puts
          puts
          puts port_chosen
          puts
          puts
          port_in_use = @node_ports[port_chosen]
          puts
          puts
          puts port_in_use
          puts
          puts
          node_aux = ['127.0.0.1:', port_in_use].join
          node = [node_aux]

          client = Yora::Client.new(node)
          puts client.inspect
          if !request.eql?('')
            r = request.split
            data = r[1].sub('/','').sub('?',' ')
            puts data
            response = ''
            if data.include? 'set'
              response = client.command(data)
            elsif data.include? 'get'
              response = client.query(data)
            else
              throw StandardError
            end
            puts "RESPOSTA #{response}"
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