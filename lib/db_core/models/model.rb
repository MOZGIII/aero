class Model
  # Описывает какие поля не надо преобразовывать в NULL
  def Model.not_needs_to_set_null()
    []
  end

  # Метод, создающий в БД таблицу, описывающую модель
  def Model.create_table(connection)
    return false
  end

  # Имя таблицы, описывающей модель
  def table_name()
    self.class.table_name()
  end

  # См. table_name()
  def Model.table_name()
    self.to_s.gsub(/(\W)/, '_\1').downcase + 's'
  end

  # Конструктор
  def initialize(attributes = {})
    @attributes = {}
  end

  # Позволяет обращаться к полям объекта, минуя @attributes
  def [](name)
    @attributes[name.to_sym]
  end

  # Позволяет присваивать полям объекта значения, минуя @attributes
  def []=(name, value)
    if value == '' and !Model.not_needs_to_set_null().include?(name.to_sym)
      value = nil
    end
    @attributes[name.to_sym] = value
  end

  # Синхронизирует объет с БД
  def save(connection)
    query = ''
    params = []
    if self[:id].nil? 
      query = "INSERT INTO #{self.table_name()}(" +
        (@attributes.keys - [:id]).join(', ') + ') VALUES(' +
        (@attributes.keys - [:id]).map{ |k| '?' }.join(', ') + ') RETURNING id'
      params = (@attributes.keys - [:id]).map{ |k| self[k] }
    else
      query = "UPDATE #{self.table_name()} SET " +
        (@attributes.keys - [:id]).map{ |k| "#{k} = ?" }.join(', ') +
        ' WHERE id = ? RETURNING id'
      params = (@attributes.keys - [:id]).map{ |k| self[k] } << self[:id]
    end
    rs = connection.select_one(query, *params)
    self[:id] = rs[0].to_i
  end

  # Достает из БД все объекты данного вида
  def Model.find_all(connection)
    query = []
    res = []
    query = ["SELECT * FROM #{table_name()}"]
    connection.select_all(*query) do |r|
      o = self.new
      r.column_names.each do |c|
        o[c.to_sym] = r[c]
      end
      res << o
    end
    return res
  end

  # Достает из БД объект по его id
  def Model.find_first(connection, id)
    id = id.to_i
    query = ["SELECT * FROM #{table_name()} WHERE id = ?", id]
    r = connection.select_one(*query)
    return nil if r.nil?
    o = self.new
    r.column_names.each do |c|
      o[c.to_sym] = r[c]
    end
    return o
  end

  # Удаляет объект в БД

  def destroy(connection)
    unless self[:id].nil?
      connection.do("DELETE FROM #{table_name()} WHERE id = ?", self[:id])
    end
  end
end
