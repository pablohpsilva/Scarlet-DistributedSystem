require 'socket'
require 'open-uri'

def server_conf(folder)
  conf = {
    'domain'   => 'localhost',
    'port'     => '8888',
    'root_page'=> 'index.html',
    # Files will be served from this directory
    'web_root' => folder,
    # Treat as binary data if content type cannot be found
    'default_content_type' => 'application/octet-stream',
    # Map extensions to their content type
    'content_type_mapping' => {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpeg'
    }
  }
  return conf
end

def content_type(path)
  ext = File.extname(path).split(".").last
  SERV_CONFIG['content_type_mapping'].fetch(ext, SERV_CONFIG['default_content_type'])
end

puts "Starting up server..."
server = TCPServer.new("localhost",8888)

loop do
	Thread.start(server.accept) do |client|
		#puts "#{client.peeraddr[0]}\n#{client.peeraddr[1]}\n#{client.peeraddr[2]}\n#{client.peeraddr[3]}\n"
		puts "Server: Connection from #{client.peeraddr[2]} at #{client.peeraddr[3]}"
		puts "Server: got input from client"
		pasta_raiz = client.gets.strip
		porta = client.gets.strip
		
		SERV_CONFIG = server_conf(pasta_raiz)
		
		puts "Pasta Raiz: #{pasta_raiz}\nPorta: #{porta}\n"

		path = File.join(pasta_raiz, SERV_CONFIG['root_page']) if File.directory?(pasta_raiz)		
		
		if File.exist?(path) && !File.directory?(path)
			File.open(path, "rb") do |file|				
				client.puts "HTTP/1.1 200 OK\r\nContent-Type: #{content_type(file)}\r\n"+
				"Content-Length: #{file.size}\r\nConnection: close\r\n\n"

				client.puts open(path).readlines
			end
		else
			message = "<html>\n" +
			"<head>\n" +
			" <title>404 Not Found </title>\n" +
			"</head>\n" +
			"<body>\n" +
			" <h1>Scarlet: 404 Not Found\n" +
			" <h2>File not found. Could you please try again later?\n" +
			"</body>\n" +
			"</html>\n"

			# respond with a 404 error code to indicate the file does not exist
			client.puts "HTTP/1.1 404 Not Found\r\n" +
			"Content-Type: text/html\r\n" +
			"Content-Length: #{message.size}\r\n" +
			"Connection: close\r\n\n"

			client.puts message
		end
	end  #end thread conversation
end   #end loop