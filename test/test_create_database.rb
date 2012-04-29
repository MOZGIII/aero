$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'db_core/create_database'

class TestCreateDatabase < Test::Unit::TestCase
  def test_creation
    creator = CreateDatabase.new
    assert(creator.create() >= CreateDatabase::CREATE_OK,
      'Процесс создания пустой БД не может завершиться успешно!')
  end

  def test_insert_test_data()
    creator = CreateDatabase.new
    creator.insert_test_data()
    db = DbDriver.instance
    res = db.select_one("SELECT count(*) FROM flights")
    assert(res[0].to_i == 1, 'Тестовые данные внесены успешно!')
    User.create_admin(db)
    assert(User.check_user(db, 'admin', 'qwerty'), 'Ошибка добавления администратора!')
    DbDriver.close()
  end

  def test_models()
    db = DbDriver.instance
    cs = Company.find_all(db)
    assert(cs.size == 1, 'Не работает find_all для модели Company!')
    fs = Flight.find_all(db)
    assert(fs.size == 1, 'Не работает find_all для модели Flight!')
    assert(!fs[0].company.nil?, 'Не находятся связанные объекты!')
    DbDriver.close()
  end
end
