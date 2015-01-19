require 'socket'      # Sockets are in standard library
require 'uri'
require 'digest'

$host = ARGV[0]
$port = ARGV[1]
$path = ARGV[2]
$action = ARGV[3]
$first_name= ARGV[4]
$last_name = ARGV[5]
$email = ARGV[6]
$age = ARGV[7]
$gender = ARGV[8]
$password = ARGV[9]
$telephone = ARGV[10]
$interests = ARGV[11]
$friends = ARGV[12]

if  ARGV.length > 3
	puts $host
	puts $port
	puts $path
	puts $action
	puts $first_name
	puts $last_name
	puts $email
	puts $age
	puts $gender
	puts $password
	puts $telephone
	puts $interests
	puts $friends

	socket = TCPSocket.open($host,$port)  	# Connect to server

	$action = $action.to_s.downcase

	#O GET precisa somente do email do usuario que deseja buscar
	if $action.include?('get')
		$email = ARGV[4]
		#GET /index.html?acao=oi&valor=ola HTTP/1.1
		request = "http://"+$host+":"+$port+$path+"?acao="+$action+"&value="+$email

	# O POST envia todos os dados do novo usuário a ser cadastrado, num primeiro instante a tabela de friends é nula
	elsif $action.include?('post')
		puts "Entrou no POST\n"
		$password = Digest::MD5.hexdigest($password)

		if $friends.nil?
			request = "http://"+$host+":"+$port+$path+"?acao="+$action+"&first_name="+$first_name+"&last_name="+$last_name+"&email="+$email+"&age="+$age+"&gender="+$gender+"&password="+$password+"&telephone="+$telephone+"&interests="+$interests
		else
			request = "http://"+$host+":"+$port+$path+"?acao="+$action+"&first_name="+$first_name+"&last_name="+$last_name+"&email="+$email+"&age="+$age+"&gender="+$gender+"&password="+$password+"&telephone="+$telephone+"&interests="+$interests+"&friends="+$friends
		end

	# O PUT envia o email, que é o ID do usuario, que deseja buscar para atualizar, enviando o valor igual a interests ou friends
	# e o dado a ser gravado em interests ou friends;
	elsif $action.include?('put')
		$email = ARGV[4]
		value = ARGV[5]
		data = ARGV[6]
		if data.include?(" ")
				data = data.split.join('%20')
		end
		request = "http://"+$host+":"+$port+$path+"?acao="+$action+"&usuario="+$email+"&value="+value+"&dado="+data

	# O DELETE também envia o email do usuário que desejar, juntamente com o valor igual a interests ou friends
	# e o dado que deseja deletar
	elsif $action.include?('delete')
		$email = ARGV[4]
		value = ARGV[5]
		data = ARGV[6]
		request = "http://"+$host+":"+$port+$path+"?acao="+$action+"&usuario="+$email+"&value="+value+"&dado="+data
	else
		request = "ERROR"
	end

	puts request
	socket.print(request)
	puts "Mensagem enviada\n"
	response = socket.read              	# Read complete response
	puts "Leu resposta\n"
	headers, body = response.split("\r\n\r\n", 2)
	print headers
	print "\n\n"
	print body                 	# And display it

else
  print "Nope. Try again \n"
end
