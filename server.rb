require 'socket'
require 'uri'

# Load server configurations
load 'serv.conf.rb'


# Files will be served from this directory
# WEB_ROOT = './public'

# This file will contain the server configurations.
# CONFIG   = 'conf.json'

# Map extensions to their content type
# Works just like a dictionary~PHP
# CONTENT_TYPE_MAPPING = {
#   'html' => 'text/html',
#   'txt' => 'text/plain',
#   'png' => 'image/png',
#   'jpg' => 'image/jpeg'
# }

# Treat as binary data if content type cannot be found
#DEFAULT_CONTENT_TYPE = 'application/octet-stream'

# This helper function parses the extension of the
# requested file and then looks up its content type.

def content_type(path)
  ext = File.extname(path).split(".").last
  SERV_CONFIG['content_type_mapping'].fetch(ext, SERV_CONFIG['default_content_type'])
end

# This helper function parses the Request-Line and
# generates a path to a file on the server.

def requested_file(request_line)
  request_uri  = request_line.split(" ")[1]
  path         = URI.unescape(URI(request_uri).path)

  clean = []

  # Split the path into components
  parts = path.split("/")

  parts.each do |part|
    # skip any empty or current directory (".") path components
    next if part.empty? || part == '.'
    # If the path component goes up one directory level (".."),
    # remove the last clean component.
    # Otherwise, add the component to the Array of clean components
    part == '..' ? clean.pop : clean << part
  end

  # return the web root joined to the clean path
  File.join(SERV_CONFIG['web_root'], *clean)
end

# Except where noted below, the general approach of
# handling requests and generating responses is
# similar to that of the "Hello World" example
# shown earlier.

server = TCPServer.new(SERV_CONFIG['domain'], SERV_CONFIG['port'])

loop do
  #Server will accept a request
  socket       = server.accept
  #This is a GET.
  request_line = socket.gets

  STDERR.puts request_line

  path = requested_file(request_line)
  path = File.join(path, SERV_CONFIG['root_page']) if File.directory?(path)

  # Make sure the file exists and is not a directory
  # before attempting to open it.
  if File.exist?(path) && !File.directory?(path)
    File.open(path, "rb") do |file|
      socket.print "HTTP/1.1 200 OK\r\n" +
        "Content-Type: #{content_type(file)}\r\n" +
        "Content-Length: #{file.size}\r\n" +
        "Connection: close\r\n"

      socket.print "\r\n"

      # write the contents of the file to the socket
      IO.copy_stream(file, socket)
    end
  else
    message = "<html>" +
      "<head>" +
      " <title>404 Not Found </title>" +
      "</head>" +
      "<body>" +
      " <h1>Scarlet: 404 Not Found" +
      " <h2>File not found. Could you please try again later?" +
      "</body>" +
      "</html>"

    # respond with a 404 error code to indicate the file does not exist
    socket.print "HTTP/1.1 404 Not Found\r\n" +
      "Content-Type: text/html\r\n" +
      "Content-Length: #{message.size}\r\n" +
      "Connection: close\r\n"

    socket.print "\r\n"

    socket.print message
  end

  socket.close
end
