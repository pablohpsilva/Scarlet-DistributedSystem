require 'digest/md5'
load './DatabaseManager.rb'

@distributed_servers = nil
@interval = '0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z'.split(',')

@interval.each do |item|
  puts item
end

puts @interval.length

puts Digest::MD5.hexdigest("Hello World")

@teste = DatabaseManager.new([ ['localhost', 8888], ['localhost', 8889], ['localhost', 8890], ['localhost', 8891] ])