require 'cgi'
require 'uri'
load 'ServerStrings.rb'

class HTTP

  private
    @server_strings = ServerStrings.new()
    @server_configurations

    def load_default_page(client, server_configurations)
      message = server_configurations.get_server['root_page']
      client.print @server_strings.http_200_ok(message.size)
      client.print message
    end

    def process_file(path, server_configurations)
      File.open(path, 'rb') do |file|
        content = server_configurations.content_type(file)
        client.print @server_strings.http_200_ok(file.size,content)

        # write the contents of the file to the socket
        IO.copy_stream(file, client)
      end
    end

  public
    def initialize(server_configurations)
      @server_configurations = server_configurations
    end

    def Get(client, server_configurations)
      request_line = client.gets
      STDERR.puts request_line

      path = server_configurations.requested_file(request_line)

      if server_configurations.get_server['root_page'] != 'index.html' && path == server_configurations.get_server['root_folder']
        load_default_page(client, server_configurations)

      else

        path = File.join(path, server_configurations.get_server['root_page']) if File.directory?(path)

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          File.open(path, 'rb') do |file|
            content = server_configurations.content_type(file)
            client.print @server_strings.http_200_ok(file.size,content)

            # write the contents of the file to the socket
            IO.copy_stream(file, client)
          end

        else
          message = server_configurations.get_server['default_error_page']

          # respond with a 404 error code to indicate that the file does not exist
          client.print @server_strings.http_400_error(message.size)
          client.print message
        end

        client.close
      end
    end

    def Post(client, server_configurations)
      puts "\n\nRecebeu metodo POST\n\n"

      # Separa a string por palavra e as armazena em um array
      s = request_line.split

      # Separa a URL em categorias, como Scheme, Host, Path, Query e Fragment
      u = URI.parse(s[1])
      puts "#{s[0]} #{u.path} #{s[2]} \nHOST: #{u.host}"
      puts u.query
      #puts "\nPATH = "+ u.path #puts "\nQUERY = " + u.query
      p = CGI.parse(u.query)
      values = p.values

      path = server_configurations.requested_file(request_line)

      if server_configurations.get_server['root_page'] != 'index2.html' && path == server_configurations.get_server['root_folder']
        load_default_page(client, server_configurations)

      else
        path = File.join(path, server_configurations.get_server['root_page']) if File.directory?(path)

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          File.open(path, 'rb') do |file|
            content = server_configurations.content_type(file)
            client.print @server_strings.http_200_ok(file.size,content)

            # write the contents of the file to the socket
            IO.copy_stream(file, client)
          end

        else
          message = server_configurations.get_server['default_error_page']

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
end