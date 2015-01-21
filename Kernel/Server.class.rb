require 'socket'
require 'uri'
require 'json'
require 'cgi'
require 'securerandom'
require 'digest'
load '../Kernel/User.class.rb'
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


    def start(client, request)
      request_line = request.split(' ')
      STDERR.puts request_line
      method = request_line[0]
      if method.include?('GET')
        self.http_get(client, request_line[1])
      elsif method.include?('POST')
        self.http_post(client, request_line[1])
      elsif method.include?('PUT')
        self.http_put(client,request_line[1])
      elsif method.include?('DELETE')
        self.http_delete(client,request_line[1])
      else
        client.print "\nAcao nao encontrada, tente novamente.\n"
      end

      client.close
    end

    # Esse metodo e usado para buscar um dado
    def http_get(client, request_line)
      basic_data = http_basics(request_line)

      v = basic_data['values'].split
      md5 = Digest::MD5.hexdigest(v[0])
      get_User = User.new
      get_User.get_user_on_file(md5)

      message = get_User.user_to_json.to_json
      client.puts(@server_strings.http_200_ok(message.length, 'text/json'))
      client.puts(message)
      # client.print @server_strings.http_200_ok(message.length, 'text/json')
      # client.print message
    end

    def http_put(client, request_line)
      basic_data = http_basics(request_line)

      v = basic_data['values'].split
      v[0] = Digest::MD5.hexdigest(v[0].gsub(',',''))
      update_User = User.new
      if v[1].gsub(',','').eql?('friends')
        update_User.get_user_on_file(v[0])
        friends = update_User.friends
        if friends.eql?([])
          update_User.friends = Digest::MD5.hexdigest(v[2]).split
        else
          update_User.friends = [friends+', '+Digest::MD5.hexdigest(v[2])]
        end
        update_User.save_user_on_file
      elsif v[1].gsub(',','').eql?('interests')
        update_User.get_user_on_file(v[0])
        interests = update_User.interests
        if interests.eql?([])
          update_User.interests = [v[2]]
        else
          update_User.interests = [interests+', '+v[2]]
        end
        update_User.save_user_on_file
      end
    end

    def http_delete(client, request_line)
      basic_data = http_basics(request_line)

      v = basic_data['values'].split
      v[0] = Digest::MD5.hexdigest(v[0].gsub(',',''))
      delete_user_data = User.new
      if v[1].gsub(',','').eql?('friends')
        delete_user_data.get_user_on_file(v[0])
        if delete_user_data.friends.eql?([])
          client.print "Nao ha amigos em sua lista de amigos!\n"
        else
          delete_user_data.friends.delete(Digest::MD5.hexdigest(v[2]))
        end
        delete_user_data.save_user_on_file
      elsif v[1].gsub(',','').eql?('interests')
        delete_user_data.get_user_on_file(v[0])
        if delete_user_data.interests.eql?([])
          client.puts "Nao ha interesses em sua lista de interesses!\n"
        else
          interests = delete_user_data.interests.to_s.gsub(v[2],'')
          delete_user_data.interests = interests.split
          puts delete_user_data.interests
          puts interests
        end
        delete_user_data.save_user_on_file
      end
    end

    # Esse metodo e usado para salvar um dado
    def http_post(client, request_line)
      basic_data = http_basics(request_line)

      v = basic_data['values'].split
<<<<<<< HEAD
      new_User = User.new(v[0].gsub(',',''), v[1].gsub(',',''), v[2].gsub(',',''), v[3].gsub(',',''), v[4].gsub(',',''), v[5].gsub(',',''), v[6].gsub(',',''), v[7])
      #new_User.interests = [new_User.interests]
      #new_User User.new

      #new_User = User.new('jaozin','feijao','j@f.com',198, 'm', 'gigante', '12312312312312', ['princesas', 'pes de feijao', 'unicornios', 'matar gigantes'], ['Pablo', 'Nayara'])
      #new_User = User.new('jaozin','feijao','j@f.com',198, 'm', 'gigante', '12312312312312', ['princesas', 'pes de feijao', 'unicornios', 'matar gigantes'], nil)
=======
      # ee = v.map{|e| e.gsub(',','')}
      puts v.inspect
      ee = v.map{|e| e.gsub(',','')}
      new_User = User.new(ee[0], ee[1], ee[2], ee[3], ee[4], ee[5], ee[6], ee[7])
      new_User.interests = [new_User.interests]
      # new_User User.new

      alfredo = User.new('alfredo', 'gomes', 'a@a.c', 21, 'M', 'graveto', '3432102954', ['mulheres', 'carros', 'bolsa'], [])
      wander = User.new('wander', 'gomes', 'w@a.c', 20, 'M', '123graveto', '3432102954', ['mulheres', 'corrida', 'brinco'], [])
      luks = User.new('luks', 'gomes', 'l@a.c', 19, 'M', 'graveto123', '5432102954', ['mulheres', 'games', 'broca'], [])
      gata = User.new('gata', 'gostosa', 'tesao@a.c', 25, 'F', 'douatudo', '12312312313', ['pintinhos'], [])

      alfredo.friends = [wander, luks, gata]
      wander.friends = [alfredo, luks, gata]
      luks.friends = [wander, alfredo, gata]
      gata.friends = [alfredo]

      new_User.friends= [alfredo, wander, luks, gata]

      # new_User = User.new('jaozin','feijao','j@f.com',198, 'm', 'gigante', '12312312312312', ['princesas', 'pes de feijao', 'unicornios', 'matar gigantes'], nil)
>>>>>>> 2b47b2af3e343ce8f7fec773faa8ca7739ca5bf0
      if new_User.instance_of?(User)
        new_User.save_user_on_file
      end
      client.print new_User.user_to_json.to_json
      # client.close
    end

end