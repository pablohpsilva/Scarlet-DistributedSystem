require 'socket'
require 'uri'
require 'json'
load 'Util.rb'
load 'Server.class.rb'

def main
  # Except where noted below, the general approach of
  # handling requests and generating responses is
  # similar to that of the "Hello World" example
  # shown earlier.
  server = TCPServer.new( SERV_CONFIG.get_server['domain'], SERV_CONFIG.get_server['port'] )

  puts 'Scarlet server is running...'

  loop do

    #Server will accept a request
    Thread.start(server.accept) do |client|

      #This is a GET.
      request_line = client.gets

      STDERR.puts request_line

      path = SERV_CONFIG.requested_file(request_line)

      if SERV_CONFIG.get_server['root_page'] != 'index.html' && path == SERV_CONFIG.get_server['web_root']
        message = SERV_CONFIG.get_server['root_page']
        client.print  "HTTP/1.1 200 OK\r\n" +
                          "Content-Type: text/html\r\n" +
                          "Content-Length: #{message.size}\r\n" +
                          "Connection: close\r\n"

        client.print "\r\n"
        client.print message

      else

        path = File.join(path, SERV_CONFIG.get_server['root_page']) if File.directory?(path)

        # Make sure the file exists and is not a directory
        # before attempting to open it.

        if File.exist?(path) && !File.directory?(path)
          File.open(path, 'rb') do |file|
            content = SERV_CONFIG.content_type(file)
            client.print  "HTTP/1.1 200 OK\r\n" +
                              "Content-Type: #{content}\r\n" +
                              "Content-Length: #{file.size}\r\n" +
                              "Connection: close\r\n"

            client.print "\r\n"

            # write the contents of the file to the socket
            IO.copy_stream(file, client)
          end

        else
          message = SERV_CONFIG.get_server['default_error_page']

          # respond with a 404 error code to indicate the file does not exist
          client.print  "HTTP/1.1 404 Not Found\r\n" +
                            "Content-Type: text/html\r\n" +
                            "Content-Length: #{message.size}\r\n" +
                            "Connection: close\r\n"

          client.print "\r\n"
          client.print message
        end

        client.close
      end
    end
  end
end


=begin
  The magic starts right here. Scarlet welcomes you
=end
if !(ARGV.length < 1) && !(ARGV.length > 2)
  if ARGV[0].split('.')[1] == 'json'
    SERV_CONFIG = Server.new( ARGV[0] ) #from the Server class
    main
  elsif ARGV.length == 2
    SERV_CONFIG = Server.new( ARGV[0], ARGV[1] )  #from the Server class
    main
  else
    how_to_use_scarlet #from Util.rb
  end
else
  how_to_use_scarlet #from Util.rb
end
