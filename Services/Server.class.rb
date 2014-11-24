require 'socket'
require 'uri'
require 'json'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'

class Server

  private
    @server_config = nil
    @server_strings = nil
    @server_name = ''

    def get_answer (message, response)
      return {
          'response' => response,
          'message' => message
      }
    end

  public
    def initialize(server_name = nil, folderOrJson = nil, port = nil)
      @server_strings = ServerStrings.new()
      @server_name = ( server_name == nil ) ? 'untitled' : server_name
      @server_config = ( port == nil ) ? @server_config = ServerForger.new( folderOrJson ) : @server_config = ServerForger.new( folderOrJson, port )
    end

    def start (client)
      request_line = client.gets
      STDERR.puts request_line
      path = @server_config.requested_file(request_line)

      if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
        message = @server_config.get_server['root_page']
        response = @server_strings.http_200_ok(message.size)
        return get_answer(message,response)

      else
        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          File.open(path, 'rb') do |file|
            content = @server_config.content_type(file)
            response = @server_strings.http_200_ok(file.size,content)
            #message = IO.copy_stream(file, client)
            IO.copy_stream(file, client)
            return get_answer(message,response)
          end

        else
          message = @server_config.get_server['default_error_page']
          # respond with a 404 error code to indicate that the file does not exist
          response = @server_strings.http_400_error(message.size)
          return get_answer(message,response)
        end
      end
    end

    def get_name
      return @server_name
    end

end