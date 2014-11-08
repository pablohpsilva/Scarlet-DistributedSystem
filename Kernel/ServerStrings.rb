class ServerStrings
  public
    def using_scarlet
      aux = "\nHello... This is Scarlet, the server. How do you do?"
      aux += 'Look, this is how you should use me: '
      aux += "\n\t Usage: ruby server.rb [conf.json ,[FOLDER, PORT]]"
      aux += "\nHere, take a look at these examples:"
      aux += "\t $ruby server.rb conf.json"
      aux += "\t $ruby server.rb \".\/public\" 8888 "
      aux += "\nGot it? Great! Please, try again.\n\n"
      return aux
    end

    def http_200_ok (message_length, message = 'text/html')
      return  "HTTP/1.1 200 OK\r\n" +
              "Content-Type: #{message}\r\n" +
              "Content-Length: #{message_length}\r\n" +
              "Connection: close\r\n" +
              "\r\n"
    end

    def http_400_error (message_length)
        return  "HTTP/1.1 404 Not Found\r\n" +
                "Content-Type: text/html\r\n" +
                "Content-Length: #{message_length}\r\n" +
                "Connection: close\r\n"
    end
end