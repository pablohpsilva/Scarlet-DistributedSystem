require 'socket'
require 'uri'
require 'json'
require 'cgi'
require 'securerandom'
require 'digest'
load '../Kernel/ServerStrings.rb'
load '../Kernel/ServerForger.class.rb'

class Server

  private
    @server_config = nil
    @server_strings = nil
    @server_name = nil

    def load_default_page(client)
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

    def http_basics(request_line)
      STDERR.puts "Server on duty: #{get_name}"
      STDERR.puts request_line

      u = URI.parse(request_line)
      puts "\nGET #{u.path} HTTP/1.0\r\n\r\nHOST: #{u.host} \n#{u.query}"
      values = CGI.parse(u.query).values
      u.path.delete! '/'

      path = @server_config.requested_file(u.path)
      return {
          'path' => path,
          'values' => values.to_s.downcase.delete("[\"]")
      }
    end

  public
    #def initialize(server_name = nil, folderOrJson = nil, port = nil)
    def initialize(port = nil, address = 'localhost')
      @server_name = SecureRandom.urlsafe_base64
      @server_strings = ServerStrings.new
      @server_config = ServerForger.new(address, port)
    end

    def get_server_configs
      return @server_config
    end

    def get_name
      @server_name
    end


    def start(client)
      request_line = client.gets
      STDERR.puts request_line
      if request_line.include?('http_get')
        self.http_get(client, request_line)
      elsif request_line.include?('http_post')
        self.http_post(client, request_line)
      elsif request_line.include?('http_put')
        self.http_put(client,request_line)
      elsif request_line.include?('http_delete')
        self.http_delete(client,request_line)
      else
        client.print "\nAcao nao encontrada, tente novamente.\n"
      end

      client.close
    end

    # Esse metodo e usado para buscar um dado
    def http_get(client, request_line)
      basic_data = http_basics(request_line)

      if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
        load_default_page(client)
      else
        path = File.join(basic_data['path'], @server_config.get_server['root_page']) if File.directory?(basic_data['path'])

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          process_file(path,client)
        else
          respond_error_page(client)
        end

        # Aqui recupera o email do usuário e converte em seu equivalente MD5 para buscar na tabela correspondente
        v = basic_data['values'].split
        ee = v.map{|e| e.gsub(',','')}
        ee[1] = Digest::MD5.hexdigest(ee[1])
        get_User = User.new.from_json_data(ee[1])
      end
      client.close
    end

    def http_put(client, request_line)
      puts "Entrou no PUT\n"
      basic_data = http_basics(request_line)

      if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
        load_default_page(client)

      else
        path = File.join(basic_data['path'], @server_config.get_server['root_page']) if File.directory?(basic_data['path'])

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          process_file(path, client)
        else
          respond_error_page(client)
          return nil
        end

        # Aqui recupera o email, o nome da tabela, interests ou friends, e o valor a ser gravado
        # O email é convertido para seu equivalente MD5 para poder buscar pelo usuário na tabela correspondente
        v = basic_data['values'].split
        ee = v.map{|e| e.gsub(',','')}
        ee[1] = Digest::MD5.hexdigest(ee[1])

        # ee[1] = email
        # ee[2] = valor ou nome da tabela
        # ee[3] = valor do dado a ser gravado
        update_User = User.new.from_json_data(ee[1..3])
      end
      client.close
    end

    def http_delete(client, request_line)
      basic_data = http_basics(request_line)

      if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
        load_default_page(client)

      else
        path = File.join(basic_data['path'], @server_config.get_server['root_page']) if File.directory?(basic_data['path'])

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          puts "IF\n"
          process_file(path, client)
        else
          respond_error_page(client)
          return nil
        end

        # Aqui recupera o email, o nome da tabela, interests ou friends, e o valor a ser removido
        # O email é convertido para seu equivalente MD5 para poder buscar pelo usuário na tabela correspondente
        v = basic_data['values'].split
        ee = v.map{|e| e.gsub(',','')}
        ee[1] = Digest::MD5.hexdigest(ee[1])

        # ee[1] = email
        # ee[2] = valor ou nome da tabela
        # ee[3] = valor do dado a ser removido
        delete_user_data = User.new.from_json_data(ee[1..3])
      end
      client.close
    end

    # Esse metodo e usado para salvar um dado
    def http_post(client, request_line)
      basic_data = http_basics(request_line)

      if @server_config.get_server['root_page'] != 'index.html' && path == @server_config.get_server['root_folder']
        load_default_page(client)

      else
        path = File.join(basic_data['path'], @server_config.get_server['root_page']) if File.directory?(basic_data['path'])

        # Make sure the file exists and is not a directory
        # before attempting to open it.
        if File.exist?(path) && !File.directory?(path)
          process_file(path, client)
        else
          respond_error_page(client)
          return nil
        end

        v = basic_data['values'].split
        ee = v.map{|e| e.gsub(',','')}
        # ee[1] = first_name
        # ee[2] = last_name
        # ee[3] = email
        # ee[4] = age
        # ee[5] = gender
        # ee[6] = password
        # ee[7] = telephone
        # ee[8] = interests
        new_User = User.new.from_json_data(ee[1..8])
        if new_User.instance_of?(User)
          new_User.save_user_on_file
        end

      end
      client.close
    end

end