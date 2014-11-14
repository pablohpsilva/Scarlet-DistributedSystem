require 'socket'
require 'uri'
require 'json'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'

class Server

	@server_config = nil
	@serverStrings = ServerStrings.new()
	@server_name = ''

	public
	def initialize(server_name = nil, folderOrJson = nil, port = nil)
		@server_name = ( server_name == nil ) ? 'untitled' : server_name
		@server_config = ( port == nil ) ? @server_config = Server.new( folderOrJson ) : @server_config = Server.new( folderOrJson, port )
	end

	def start_server (client)
		request_line = client.gets

		STDERR.puts request_line

		path = @server_config.requested_file(request_line)

		if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
		message = @server_config.get_server['root_page']
		client.print @serverStrings.http_200_ok(message.size)
		client.print message

		else

		path = File.join(path, @server_config.get_server['root_page']) if File.directory?(path)

		# Make sure the file exists and is not a directory
		# before attempting to open it.
		if File.exist?(path) && !File.directory?(path)
			File.open(path, 'rb') do |file|
			content = @server_config.content_type(file)
			client.print @serverStrings.http_200_ok(file.size,content)

			# write the contents of the file to the socket
			IO.copy_stream(file, client)
			end

		else
			message = @server_config.get_server['default_error_page']

			# respond with a 404 error code to indicate that the file does not exist
			client.print @serverStrings.http_400_error(message.size)
			client.print message
		end

		client.close
		end
	end

end