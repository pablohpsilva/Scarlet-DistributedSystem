class Stack
	# O ultimo parametro pode ser nulo, por isso é iniciado com nil
	def imprimeParametros(acao,valor,dado=nil)	
		a = acao.to_s
		a = a.downcase.delete "[\"]"
		v = valor.to_s
		v = v.downcase.delete "[\"]"		
		puts "\nExemplo teste de recebimento dos parametros do POST do cliente.\n"		
		puts "\nAcao = #{a}\nValor = #{v}\n"
		if dado != nil
			d = dado.to_s
			d = d.downcase.delete "[\"]"
			puts "Dado = #{d}\n\n"
		end
	end
end