#!/usr/local/bin/ruby
# coding: UTF-8

if Object.const_defined?("Encoding")
  Encoding.default_external = "UTF-8"
  Encoding.default_internal = "UTF-8"
end

$: << "."
$: << File.dirname(__FILE__)

require 'cgi'
require 'controllers/controller'
require 'convertors'

DEFAULT_CONTROLLER = 'Flights'
DEFAULT_ACTION = 'departure_list'

def valid_controllers()
  Dir[File.join(File.dirname(__FILE__), 'controllers', "*.rb")].map do
    |f| Convertors::controller_file_to_class_name(f)
  end
end

def render()
  cgi = CGI.new('html4')
  begin
    unless cgi.params.include?('controller') or
      valid_controllers.include?(cgi.params['controller'][0])
      cgi.params['controller'] = [DEFAULT_CONTROLLER]
      cgi.params['action'] = [DEFAULT_ACTION]
    end
    c = eval(cgi.params['controller'][0] + 'Controller').new(cgi)
    cgi.out({
           "type" => "text/html; charset=utf-8",
           "language" => "ru"
         }){ c.response() }
  rescue Exception => e
    cgi.out({
             "type" => "text/html; charset=utf-8",
             "language" => "ru"
           }){ display_errors(e) }
  end
end

def display_errors(e)
  "
<html>
  <head><title>Error!</title></head>
  <body>#{e.message}<br>#{e.backtrace.join('<br>')}</body>
</html>
  "
end

render()
