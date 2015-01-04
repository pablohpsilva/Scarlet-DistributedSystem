require 'socket'
require 'uri'
require 'json'
require 'securerandom'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'
load '../Kernel/Stack.rb'

class Server

  private
    @server_config = nil
    @server_strings = nil
    @server_name = nil
    @stk = Stack.new

    def load_default_page
      message = @server_config.get_server['root_page']
      client.print @server_strings.http_200_ok(message.size)
      client.print message
    end

    def process_file(path, client)
      File.open(path, 'rb') do |file|
        content = @server_config.content_type(file)
        client.print @server_strings.http_200_ok(file.size,content)
        # write the contents of the file to the socket
        IO.copy_stream(file, client)
      end
    end

    def respond_error_page(client)
      message = @server_config.get_server['default_error_page']
      response = @server_strings.http_400_error(message.size)
      client.print response
      client.print message
      #return get_answer(message,response)
    end

  public
    #def initialize(server_name = nil, folderOrJson = nil, port = nil)
    def initialize(port = nil)
      @server_name = SecureRandom.urlsafe_base64
      @server_strings = ServerStrings.new
      @server_config = ServerForger.new(port)
    end

    def get_server_configs
      return @server_config
    end

    def get_name
      @server_name
    end


    def start(client)
      request_line = client.gets
      if request_line.include?('GET')
        self.http_get(client, request_line)
      elsif request_line.include?('POST')
        self.http_post(client, request_line)
      end

      client.close
    end


    def http_get(client, request_line)
      STDERR.puts "Server on duty: #{get_name}"
      STDERR.puts request_line
      path = @server_config.requested_file(request_line)

      if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
        load_default_page

      else
        path = File.join(path, @server_strings.get_server['root_page']) if File.directory?(path)
        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          process_file(path,client)
        else
          respond_error_page(client)
        end

      end
    end


    def http_post(client, request_line)
      #puts "\n\nRecebeu metodo POST\n\n"
      STDERR.puts "Server on duty: #{get_name}"
      STDERR.puts request_line

      # Separa a string por palavra e as armazena em um array
      s = request_line.split

      # Separa a URL em categorias, como Scheme, Host, Path, Query e Fragment
      u = URI.parse(s[1])
      puts "#{s[0]} #{u.path} #{s[2]} \nHOST: #{u.host} \n#{u.query}"
      #puts "\nPATH = "+ u.path #puts "\nQUERY = " + u.query
      #p = CGI.parse(u.query)
      #values = p.values
      values = CGI.parse(u.query).values

      path = @server_strings.requested_file(request_line)

      if @server_strings.get_server['root_page'] != 'index2.html' && path == @server_strings.get_server['root_folder']
        load_default_page

      else
        path = File.join(path, @server_strings.get_server['root_page']) if File.directory?(path)

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          process_file(path, client)
        else
          respond_error_page(client)
          return nil
        end

        action = values[0].to_s.downcase.delete "[\"]"
        stack_name = values[1].to_s.downcase.delete "[\"]"
        path_stack = "../Pilhas/#{stack_name}"
        stack_data = values[2].to_s.downcase.delete "[\"]"

        case action
          when 'criar'
            puts "Criando pilha...\n"
            message = @stk.create(path_stack)
            client.print message
          when 'push'
            puts "Encrevendo na pilha...\n"
            message = @stk.push_stack(path_stack,stack_data)
            client.print message
          when 'pop'
            puts "Tirando da pilha...\n"
            message = @stk.pop_stack(path_stack)
            client.print message
          when 'dump'
            puts "Imprimindo a pilha...\n"
            message = @stk.displaing(path_stack,stack_name)
            client.print "\n\n#{message}"
          when 'zerar'
            puts "Reiniciando a pilha...\n"
            message = @stk.delete_stack(path_stack)
            client.print message
          else
            puts "Acao #{action} nao existe\n"
        end
      end
    end

end