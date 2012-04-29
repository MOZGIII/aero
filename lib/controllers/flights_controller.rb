class FlightsController < Controller
  def is_authorized_action?()
    !([:departure_list, :arrival_list].include?(@action))
  end

  def list()
    @items = Flight.find_all(@db)
    render_template(@action)
  end

  def departure_list()
    @items = Flight.find_all(@db, true)
    @header = 'Вылетающие рейсы'
    render_template('easy_list')
  end

  def arrival_list()
    @items = Flight.find_all(@db, false)
    @header = 'Прилетающие рейсы'
    render_template('easy_list')
  end

  def edit()
    if @cgi.params.has_key?('is_commit')
      params = filter_for_params()
      if params.has_key?('id') and params['id'][0] != ''
        @item = Flight.find_first(@db, params['id'][0])
        @header = 'Редактирование информации о рейсе'
        @message = 'Информация о рейсе записана'
        if @item.nil?
          @item = Flight.new
          @header = 'Внесение новой информации о рейсах'
          @message = 'Информация о новом рейсе внесена в БД'
        end
      else
        @item = Flight.new
        @header = 'Внесение новой информации о рейсах'
        @message = 'Информация о новом рейсе внесена в БД'
      end
      params.each do |k, v|
        @item[k] = v[0] if k != 'id' and v != ''
      end
      @item.save(@db)
    else
      if @cgi.params.has_key?('id')
        @item = Flight.find_first(@db, @cgi.params['id'][0])
        @header = 'Редактирование информации о рейсе'
        if @item.nil?
          @item = Flight.new
          @header = 'Внесение новой информации о рейсах'
        end
      else
        @item = Flight.new
        @header = 'Внесение новой информации о рейсах'
      end
    end
    render_template('edit')
  end

  def destroy()
    if @cgi.params.has_key?('id') and @cgi.params['id'][0] != ''
      @item = Flight.find_first(@db, @cgi.params['id'][0])
      unless @item.nil?
        @item.destroy(@db)
        @message = 'Объект удален!'
      else
        @message = 'Объект не найден!'
      end
    end
    render_template(@action)
  end

  def FlightsController.actions(user)
    result = [[:departure_list, 'Вылетающие рейсы'],
              [:arrival_list, 'Прилетающие рейсы']]
    unless user.nil?
      result += [[:list, 'Все рейсы']]
    end
    result
  end
end
