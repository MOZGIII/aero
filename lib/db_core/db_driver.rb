# coding: UTF-8
require 'rubygems'
require 'dbi'
require 'singleton'

class DbDriver
  include Singleton

  HOST = 'localhost'
  PORT = 5432
  USER = 'worker'
  PASSWORD = 'worker'
  DBNAME = 'aero'
  DBEMPTYNAME = 'template1'

  # Возвращает указатель на установленное соединение
  def DbDriver.instance()
    if @connection.nil? or !@connection.connected?
      DbDriver.connect()
    end
    return @connection
  end

  # Устанавливает соединение с БД
  def DbDriver.connect()
    @connection = DBI.connect("dbi:Pg:dbname=#{DBNAME};host=#{HOST};port=#{PORT}",
      USER, PASSWORD, 'AutoCommit' => true, 'pg_client_encoding' => 'UTF-8')
  end

  # Устанавливает соединение с пустым репозиторием (необходимо для createdb)
  def DbDriver.empty_connection()
    if @empty_connection.nil? or !@empty_connection.connected?
      @empty_connection = DBI.connect("dbi:Pg:dbname=#{DBEMPTYNAME};host=#{HOST};port=#{PORT}",
        USER, PASSWORD, 'AutoCommit' => true, 'pg_client_encoding' => 'UTF-8')
    end
    return @empty_connection
  end

  # Закрывает соединение с БД
  def DbDriver.close()
    @connection.disconnect if @connection.connected?
  end
end