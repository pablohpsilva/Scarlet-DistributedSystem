class DatabaseManager

  @database_map = {}
  @interval = '0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z,w'.split(',')
  @ports = [8888, 8889, 8890, 8891]
  @addresses = 'localhost,localhost,localhost,localhost'.split(',')

  attr_accessor :database_map
  attr_accessor :ports
  attr_accessor :addresses

  def initialize(addresses = nil, ports = nil)
    @database_map = {}
    @interval = '0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z,w'.split(',')
    @ports = ports.nil? ? [8888, 8889, 8890, 8891] : ports
    @addresses = addresses.nil? ? 'localhost,localhost,localhost,localhost'.split(',') : addresses

    @counter = 0
    @index = 0
    @interval.each do |elem|
      if @counter < 9
        @database_map[elem] = [@addresses[@index], @ports[@index]]
      else
        @counter = -1
        @index += 1
      end
      @counter += 1
    end
  end

  def find_user_data(string_md5)
    return @database_map[string_md5.chars.first]
  end
end