require 'socket'

puts "Pasta Raiz:"
pasta_raiz = gets.chomp

puts "\nPorta:"
porta = gets.chomp
puts "\n"

clientSession = TCPSocket.new( "localhost", porta )

clientSession.puts pasta_raiz
clientSession.puts porta

puts "\n"

while !(clientSession.closed?) && (serverMessage = clientSession.gets)	
	puts serverMessage
end #end loop