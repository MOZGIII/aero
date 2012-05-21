# coding: UTF-8
class CheckInDesksController < Controller

  # формируем меню, для авторизованных пользователей появляется еще один пункт
  def CheckInDesksController.actions(user)
    result = []
    unless user.nil?
      result += [[:easy_list, 'Список стоек'],[:list, 'Редактирование стоек']]
                 
    end
    result
  end
  
  def is_authorized_action?()
    !([:easy_list].include?(@action))
  end

def list()
    @items = CheckInDesk.find_all(@db)
    render_template(@action)
end

def easy_list()
    @items = CheckInDesk.find_all(@db)
    render_template(@action)
end

def edit()
    if @cgi.params.has_key?('is_commit')
      params = filter_for_params()
      if params.has_key?('id') and params['id'][0] != ''
        @item = CheckInDesk.find_first(@db, params['id'][0])
        @header = 'Редактирование информации о стойки'
        @message = 'Информация о стойки записана'
        if @item.nil?
          @item = CheckInDesk.new
          @header = 'Внесение новой информации о стойки'
          @message = 'Информация о новой стойки внесена в БД'
        end
      else
        @item = CheckInDesk.new
        @header = 'Внесение новой информации о стойки'
        @message = 'Информация о новой стойки внесена в БД'
      end
      params.each do |k, v|
        @item[k] = v[0] if k != 'id' and v != ''
      end
      @item.save(@db)
    else
      if @cgi.params.has_key?('id')
        @item = CheckInDesk.find_first(@db, @cgi.params['id'][0])
        @header = 'Редактирование информации о стойки'
        if @item.nil?
          @item = CheckInDesk.new
          @header = 'Внесение новой информации о стойки'
        end
      else
        @item = CheckInDesk.new
        @header = 'Внесение новой информации о стойки'
      end
    end
    render_template('edit')
  end

  def destroy()
    if @cgi.params.has_key?('id') and @cgi.params['id'][0] != ''
      @item = CheckInDesk.find_first(@db, @cgi.params['id'][0])
      unless @item.nil?
        @item.destroy(@db)
        @message = 'Объект удален!'
      else
        @message = 'Объект не найден!'
      end
    end
    render_template(@action)
  end



end
