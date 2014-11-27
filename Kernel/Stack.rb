class Stack < Array
	def create(file_name)
		if File.exist?(file_name)
			return "\nArquivo ja existe"
		elsif
			f = File.new(file_name, "a+")
			f.close
			return "\nPilha criada com sucesso"
		end
	end

	def push_stack(file_name, data)
		if File.exist?(file_name)
			File.open(file_name,"a+") do |f|
				f.write(data+"\n")
				f.close
			end
			return "\nDado [#{data}] inserido com sucesso\n"
		else
			return "Arquivo nao encontrado...\n"
		end
	end

	def pop_stack(file_name)
		if File.exist?(file_name)
			contents = []
			#counter = 0
			File.open(file_name, "r") do |infile|
				while (line = infile.gets)
					contents.push(line)
				end
			end
			removed = contents.pop
			File.open(file_name,"w") do |file|
				file.puts contents
			end
			return "Dado: #{removed} Removido com sucesso\n"
		else
			return "Arquivo nao encontrado...\n"
		end
	end

	def displaing(file_name,stack)
		if File.exist?(file_name)
			content = File.read(file_name)
			return "Conteudo da pilha #{stack}:\n#{content}\n"
		else
			return "Arquivo nao encontrado...\n"
		end
	end

	def delete_stack(file_name)
		if File.exist?(file_name)
			File.delete(file_name)
		else
			return "\nArquivo nao existe...\n"
		end
	end

end