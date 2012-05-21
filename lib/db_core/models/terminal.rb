# coding: UTF-8
require 'db_core/models/model'

class Terminal < Model
  def Terminal.create_table(connection)
    begin
      connection.do("
CREATE TABLE terminals(
  id serial PRIMARY KEY,
  name text UNIQUE NOT NULL,
  description text,
  needs_bus boolean NOT NULL DEFAULT false
) WITH OIDS
        ")
      return true
    rescue DBI::ProgrammingError => e
      return false
    end
  end
  def Terminal.table_name()
    return 'terminals'
  end

  def bus()
   self[:needs_bus]== true ? 'Да' : 'Нет'
  end

  def initialize(attributes = {})
    @attributes = {
      :id => nil,
      :name => nil,
      :description => nil,
      :needs_bus => false
    }
    attributes.each do |k, v|
      @attributes[k] = v
    end
  end
  
    def Terminal.find_all(connection)
    query = []
    res = []
    query = ["SELECT * FROM terminals ORDER BY name"]
    connection.select_all(*query) do |r|
      f = self.new
      r.column_names.each do |c|
        f[c.to_sym] = r[c]
      end
      res << f
    end
    return res
  end


  def Terminal.find_first(connection, id)
    id = id.to_i
    query = ["SELECT * FROM terminals WHERE id = ?", id]
    r = connection.select_one(*query)
    return nil if r.nil?
    f = self.new
    r.column_names.each do |c|
      f[c.to_sym] = r[c]
    end
    return f
  end


end
