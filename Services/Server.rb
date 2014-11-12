require 'socket'
require 'uri'
require 'json'
load 'Kernel/ServerStrings.rb'
load 'Kernel/ServerForger.class.rb'

@serverStrings = ServerStrings.new()

def main
  server = TCPServer.new( SERV_CONFIG.get_server['domain'], SERV_CONFIG.get_server['port'] )

  puts 'Scarlet server is running...'

  loop do

    #Server will accept a request
    Thread.start(server.accept) do |client|

      request_line = client.gets

      STDERR.puts request_line

      path = SERV_CONFIG.requested_file(request_line)

      if SERV_CONFIG.get_server['root_page'] != 'index.html' && path == SERV_CONFIG.get_server['root_folder']
        message = SERV_CONFIG.get_server['root_page']
        client.print @serverStrings.http_200_ok(message.size)
        client.print message

      else

        path = File.join(path, SERV_CONFIG.get_server['root_page']) if File.directory?(path)

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          File.open(path, 'rb') do |file|
            content = SERV_CONFIG.content_type(file)
            client.print @serverStrings.http_200_ok(file.size,content)

            # write the contents of the file to the socket
            IO.copy_stream(file, client)
          end

        else
          message = SERV_CONFIG.get_server['default_error_page']

          # respond with a 404 error code to indicate that the file does not exist
          client.print @serverStrings.http_400_error(message.size)
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
    SERV_CONFIG = ServerForger.new( ARGV[0] ) #from the Server class
    main
  elsif ARGV.length == 2
    SERV_CONFIG = ServerForger.new( ARGV[0], ARGV[1] )  #from the Server class
    main
  else
    @serverStrings.using_scarlet #from Util.rb
  end
else
  @serverStrings.using_scarlet #from Util.rb
end