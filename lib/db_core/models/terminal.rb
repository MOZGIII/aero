# coding: UTF-8
require 'db_core/models/model'

class Terminal < Model
  def Terminal.create_table(connection)
    begin
      connection.do("
CREATE TABLE terminals(
  id serial PRIMARY KEY,
  name varchar(8) UNIQUE NOT NULL,
  description text,
  needs_bus boolean NOT NULL DEFAULT false
) WITH OIDS
        ")
      return true
    rescue DBI::ProgrammingError => e
      return false
    end
  end
end
