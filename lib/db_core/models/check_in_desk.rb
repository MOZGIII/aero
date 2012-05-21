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
  
  def CheckInDesk.table_name()
    return 'check_in_desks'
  end

  def initialize(attributes = {})
    @attributes = {
      :id => nil,
      :name => nil,
      :description => nil
    }
    attributes.each do |k, v|
      @attributes[k] = v
    end
  end

  
    def CheckInDesk.find_all(connection)
    query = []
    res = []
    query = ["SELECT * FROM check_in_desks ORDER BY name"]
    connection.select_all(*query) do |r|
      f = self.new
      r.column_names.each do |c|
        f[c.to_sym] = r[c]
      end
      res << f
    end
    return res
  end


  def CheckInDesk.find_first(connection, id)
    id = id.to_i
    query = ["SELECT * FROM check_in_desks WHERE id = ?", id]
    r = connection.select_one(*query)
    return nil if r.nil?
    f = self.new
    r.column_names.each do |c|
      f[c.to_sym] = r[c]
    end
    return f
  end


end
