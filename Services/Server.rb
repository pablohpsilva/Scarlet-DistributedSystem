require 'socket'
require 'cgi'
require 'uri'
require 'json'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'
load '../Kernel/Server.class.rb'

@server_configs
@server_strings = ServerStrings.new()
@server_instance = Server.new()
#@stk = Stack.new()

def main
	# Servidor abre uma conexão TCP para um dominio em uma porta
	server = TCPServer.new( @server_configs.get_server['domain'], @server_configs.get_server['port'] )

	puts 'Scarlet server is running...'
		
	loop do

		#Server will accept a request
		Thread.start(server.accept) do |client|

      @server_instance.start(client)

=begin
			request_line = client.gets

      if request_line.include?('GET')
        @server_instance.http_get(client)
      elsif request_line.include?('POST')
        @server_instance.http_post(client)
      end

      client.close
=end

=begin
			if request_line.include?('GET')
        #@http_instance.Get(client, @server_configs)

				STDERR.puts request_line

				path = @server_configs.requested_file(request_line)

				if @server_configs.get_server['root_page'] != 'index.html' && path == @server_configs.get_server['root_folder']
					message = @server_configs.get_server['root_page']
					client.print @serverStrings.http_200_ok(message.size)
					client.print message

				else

					path = File.join(path, @server_configs.get_server['root_page']) if File.directory?(path)

					# Make sure the file exists and is not a directory
					# before attempting to open it.
					if File.exist?(path) && !File.directory?(path)
						File.open(path, 'rb') do |file|
							content = @server_configs.content_type(file)
							client.print @serverStrings.http_200_ok(file.size,content)

							# write the contents of the file to the socket
							IO.copy_stream(file, client)
						end

					else
						message = @server_configs.get_server['default_error_page']

						# respond with a 404 error code to indicate that the file does not exist
						client.print @serverStrings.http_400_error(message.size)
						client.print message
					end

					client.close
				end

      elsif request_line.include?('POST')
        #@http_instance.Post(client, @server_configs)
				puts "\n\nRecebeu metodo POST\n\n"
				
				# Separa a string por palavra e as armazena em um array
				s = request_line.split

				# Separa a URL em categorias, como Scheme, Host, Path, Query e Fragment
				u = URI.parse(s[1])
				puts "#{s[0]} #{u.path} #{s[2]}"
				puts "HOST: #{u.host}"
				puts u.query
				#puts "\nPATH = "+ u.path
				#puts "\nQUERY = " + u.query
				p = CGI.parse(u.query)
				values = p.values

				path = @server_configs.requested_file(request_line)

				if @server_configs.get_server['root_page'] != 'index2.html' && path == @server_configs.get_server['root_folder']
					message = @server_configs.get_server['root_page']
					client.print @server_strings.http_200_ok(message.size)
					client.print message

				else
					path = File.join(path, @server_configs.get_server['root_page']) if File.directory?(path)

					# Make sure the file exists and is not a directory
					# before attempting to open it.
					if File.exist?(path) && !File.directory?(path)
						File.open(path, 'rb') do |file|
							content = @server_configs.content_type(file)
							client.print @server_strings.http_200_ok(file.size,content)

							# write the contents of the file to the socket
							IO.copy_stream(file, client)
						end

					else
						message = @server_configs.get_server['default_error_page']

						# respond with a 404 error code to indicate that the file does not exist
						client.print @server_strings.http_400_error(message.size)
						client.print message
					end

					action = values[0].to_s.downcase.delete "[\"]"
					stack_name = values[1].to_s.downcase.delete "[\"]"
					path_stack = "../Pilhas/#{stack_name}"
					stack_data = values[2].to_s.downcase.delete "[\"]"

					if action == 'criar'
						puts "Criando pilha...\n"
						result = @stk.create(path_stack)
						client.print result
					elsif action == 'push'
						puts "Encrevendo na pilha...\n"
						result = @stk.push_stack(path_stack,stack_data)
						client.print result
					elsif action == 'pop'
						result = @stk.pop_stack(path_stack)
						client.print result
					elsif action == 'dump'
						result = @stk.displaing(path_stack,stack_name)
						client.print "\n\n#{result}"
					elsif action == 'zerar'
						result = @stk.delete_stack(path_stack)
						client.print result
					else
						puts "Acao #{action} nao existe\n"
					end

					client.close
				end

			end
=end
		end
	end
end

=begin
  The magic starts right here. Scarlet welcomes you
=end
# if !(ARGV.length < 1) && !(ARGV.length > 2)
# 	if ARGV[0].split('.')[1] == 'json'
# 		@server_configs = ServerForger.new( ARGV[0] ) #from the Server class
# 		main
# 	elsif ARGV.length == 2
# 		@server_configs = ServerForger.new( ARGV[0], ARGV[1] )  #from the Server class
# 		main
# 	else
# 		@server_strings.using_scarlet #from ServerString.rb
# 	end
# else
# 	@server_strings.using_scarlet #from ServerString.rb
# end

