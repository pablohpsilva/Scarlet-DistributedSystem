#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'
require 'listen'

listener = Listen.to('utils/', only: /conf\.json/) do |modified, added, removed|
  print 'Arquivo conf.json foi modificado. Scarlet sera recarregado com novas configuracoes.'
  print 'Scarlet esta pronto. Reconfiguracao completa'
end
listener.start
sleep