require 'digest/md5'
load './DatabaseManager.rb'
load '../Kernel/User.class.rb'

@distributed_servers = nil
@interval = '0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z'.split(',')

@interval.each do |item|
  puts item
end

puts @interval.length

puts Digest::MD5.hexdigest("Hello World")

#@teste = DatabaseManager.new([ ['localhost', 8888], ['localhost', 8889], ['localhost', 8890], ['localhost', 8891] ])

@us = User.new
@us.first_name = "donald"

puts @us.first_name


alfredo = User.new('alfredo', 'gomes', 'a@a.c', 21, 'M', 'graveto', '3432102954', ['mulheres', 'carros', 'bolsa'], [])
wander = User.new('wander', 'gomes', 'w@a.c', 20, 'M', '123graveto', '3432102954', ['mulheres', 'corrida', 'brinco'], [])
luks = User.new('luks', 'gomes', 'l@a.c', 19, 'M', 'graveto123', '5432102954', ['mulheres', 'games', 'broca'], [])
gata = User.new('gata', 'gostosa', 'tesao@a.c', 25, 'F', 'douatudo', '12312312313', ['pintinhos'], [])
joao = User.new

alfredo.friends = [wander, luks, gata]
wander.friends = [alfredo, luks, gata]
luks.friends = [wander, alfredo, gata]
gata.friends = [alfredo]

alfreds = '{"id"=>"d855f08e9b9af1509bc84ff3cddf31c2", "first_name"=>"alfredo", "last_name"=>"gomes", "email"=>"a@a.c", "age"=>21, "gender"=>"M", "password"=>"graveto", "telephone"=>"3432102954", "interests"=>["mulheres", "carros", "bolsa"], "friends"=>[]}'

puts luks
puts alfredo.user_to_json

# joao.from_json_file('user.json')
# joao.friends = [alfredo]
# puts joao.inspect

new_User = User.new('jaozin','feijao','j@f.com',198, 'm', 'gigante', '12312312312312', ['princesas', 'pes de feijao', 'unicornios', 'matar gigantes'], nil)

puts JSON.pretty_generate( new_User.user_to_json )
# joao.save_user_on_file
