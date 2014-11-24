require 'socket'
require 'cgi'
require 'uri'
require 'json'
require 'net/http'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'
load '../Kernel/Stack.rb'

@serverStrings = ServerStrings.new()

def main
	# Servidor abre uma conexão TCP para um dominio em uma porta
	server = TCPServer.new( SERV_CONFIG.get_server['domain'], SERV_CONFIG.get_server['port'] )

	puts 'Scarlet server is running...'
		
	loop do

		#Server will accept a request
		Thread.start(server.accept) do |client|

			request_line = client.gets
			if request_line.include?('GET')

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
			elsif request_line.include?('POST')
				#puts "\n\nRecebeu metodo POST\n\n"
				
				# Separa a string por palavra e as armazena em um array
				s = request_line.split

				# Separa a URL em categorias, como Scheme, Host, Path, Query e Fragment
				u = URI.parse(s[1])
				request = "#{s[0]} #{u.path} #{s[2]}"
				puts request
				#puts "\nPATH = "+ u.path
				#puts "\nQUERY = " + u.query
				p = CGI.parse(u.query)
				values = p.values
				imprimir = Stack.new()
				if p.length == 3				
					imprimir.imprimeParametros(values[0],values[1],values[2])
				elsif p.length == 2
					imprimir.imprimeParametros(values[0],values[1])
				end

				path = SERV_CONFIG.requested_file(request_line)

				if SERV_CONFIG.get_server['root_page'] != 'search.rb' && path == SERV_CONFIG.get_server['root_folder']
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
		@serverStrings.using_scarlet #from ServerString.rb
	end
else
	@serverStrings.using_scarlet #from ServerString.rb
end