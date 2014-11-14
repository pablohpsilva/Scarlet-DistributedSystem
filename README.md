scarlet
=======

A server in ruby.

## How to use
```sh
  $ ruby server.rb {[[conf.json],[folder_with_html,port]]}
```
Example:
```sh
  $ ruby server.rb conf.json
```
Or
```sh
  $ ruby server.rb "./public" 8888
```
Cliente

```sh
  $ ruby client.rb "host" port "path" method_post
```
Example:
```sh
  $ ruby client.rb "localhost" 8888 "/index.html" usePost
```

## IDE and basic configurations
* Development setup for MAC OSX: http://www.createdbypete.com/articles/ruby-on-rails-development-setup-for-mac-osx
* Ruby and Sublime Text: http://zhuravel.biz/setting-up-sublime-text-for-ruby-development

## Basic skills
* Ruby load/require: http://rubylearning.com/satishtalim/including_other_files_in_ruby.html
* Ruby Hashes: http://www.tutorialspoint.com/ruby/ruby_hashes.htm
* JSON to Hash: http://rubyinrails.com/2014/04/ruby-read-json-file-to-hash/
* Ruby Class: http://www.ruby-doc.org/core-2.1.3/Class.html

## Server skills
* Ruby sockets: https://practicingruby.com/articles/implementing-an-http-file-server
* Ruby Socket Class: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/Socket.html
* TCPSocket.send: https://www.ruby-forum.com/topic/92504
* Threads: http://www.sitepoint.com/threads-ruby/
* Threads (BEST): http://www.tutorialspoint.com/ruby/ruby_socket_programming.htm

## Event listeners
* Listen: https://github.com/guard/listen

## Install
```sh
  $ sudo gem install bundler
  $ bundle install
```
