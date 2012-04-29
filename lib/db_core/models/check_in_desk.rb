# coding: UTF-8
require 'db_core/models/model'

class CheckInDesk < Model
  def CheckInDesk.create_table(connection)
    begin
      connection.do("
CREATE TABLE check_in_desks(
    id serial PRIMARY KEY,
    name varchar(16) UNIQUE NOT NULL,
    description text
) WITH OIDS
        ")
      return true
    rescue DBI::ProgrammingError => e
      return false
    end
  end
end
