# coding: UTF-8
require 'db_core/db_driver'

# Подключает все файлы db_core/model/*.rb
Dir[File.join(File.dirname(__FILE__), 'models', "*.rb")].each do |f|
  require(f)
end

class CreateDatabase
  # Используемые модели
  MODELS = [Terminal, CheckInDesk, Company, Flight, 
    CheckInDeskFlight, FlightTerminal, FlightStatus, User]
  CREATE_OK = 1 + MODELS.size

  def initialize()
  end

  # Создание пустой БД и всех таблиц. Внимание! БД сначала удаляется!
  def create
    creation_counter = 0
    @db_empty = DbDriver.empty_connection()
    creation_counter += self.drop_db()
    creation_counter += self.create_db()
    creation_counter += self.create_tables()
    @db_empty.disconnect()
    return creation_counter
  end

  # Создание пустой БД
  def create_db()
    begin
      @db_empty.do("CREATE DATABASE aero")
      return 1
    rescue DBI::ProgrammingError => e
      return 0
    end
  end

  # Удаление БД
  def drop_db()
    begin
      @db_empty.do("DROP DATABASE aero")
      return 1
    rescue DBI::ProgrammingError => e
      return 0
    end
  end

  # См. константу MODELS
  def models()
    MODELS
  end

  # Создание всех таблиц
  def create_tables()
    creation_counter = 0
    db = DbDriver.instance()
    self.models.each do |cls|
      creation_counter += 1 if cls.create_table(db)
    end
    DbDriver.close()
    return creation_counter
  end

  # Тестовое добавление данных
  def insert_test_data()
    db = DbDriver.instance()
    c = Company.new
    c[:name] = 'Сибирь'
    c[:code] = 'SB'
    c[:description] = 'Авиакомпания "Сибирь" - Россия'
    c.save(db)
    f = Flight.new
    f[:code] = (c[:code] + '00001')
    f[:arrival_date] = '2009-10-10 10:00:00'
    f[:departure_date] = '2009-10-10 22:00:00'
    f[:arrival_place] = 'Лондон'
    f[:departure_place] = 'Москва'
    f[:arrival_airport] = 'Хитроу'
    f[:departure_airport] = 'Внуково'
    f[:is_departure] = true
    f[:company_id] = c[:id]
    f.save(db)
    DbDriver.close()
  end
end
