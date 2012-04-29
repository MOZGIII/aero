# coding: UTF-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'db_core/db_driver'

class TestDbDriver < Test::Unit::TestCase
  def test_connection
    begin
      connection = DbDriver.instance
    rescue Exception => e
      assert(false, "Соединение с БД не может быть установлено! (#{e.message})")
    end
    res = connection.select_one("SELECT 1 as one")
    assert(res, 'Не могу выполнить тестовый запрос!')
    assert(res['one'].to_i == 1, 'Неверный результат запроса!')
    DbDriver.close()
  end
end
