class DatabaseManager

  private
    @database_map = nil
    @interval = '0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z,w'.split(',')

  public
    def initialize(list)
      list.each do |item|
        # pegar o tamanho do @interval e dividir pelo numero de elementos(banco de dados) da lista
        @database_map[index_do_@interval] = item
      end
    end

    def find_user_data(string_md5)
      # pega o primeiro caracter da string_md5
      # consulta o @database_map
      # retorna o valor do @database_map
    end
end