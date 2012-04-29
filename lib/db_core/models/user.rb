# coding: UTF-8

class User < Model
  def User.create_table(connection)
    begin
      connection.do("
CREATE TABLE users(
  id serial PRIMARY KEY,
  login varchar(16) UNIQUE NOT NULL,
  password varchar(16) NOT NULL,
  info text
) WITH OIDS
        ")
      return true
    rescue DBI::ProgrammingError => e
      return false
    end
  end

  def User.check_user(connection, login, password)
    id = connection.select_one("
SELECT id FROM users WHERE login = ? and password = ?
      ", login, password)
    return (id.size > 0)
  end

  def User.create_admin(connection)
    connection.do("
INSERT INTO users(login, password, info)
  VALUES('admin', 'qwerty', 'Администратор системы')
      ")
  end
end
