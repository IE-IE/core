require 'webrick'
require 'erb'
require 'json'
require './Server/Server.rb'
require './Server/app/Controller.rb'

server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => Server.root

trap 'INT' do server.shutdown end

server.mount '/', Server
server.start