# coding: UTF-8
class TerminalsController < Controller

  # формируем меню, для авторизованных пользователей появляется еще один пункт
  def TerminalsController.actions(user)
    result = []
    unless user.nil?
      result += [[:easy_list, 'Список терминалов'],[:list, 'Редактирование терминалов']]
    end
    result
  end
  
  def is_authorized_action?()
    !([:easy_list].include?(@action))
  end

  def list()
    @items = Terminal.find_all(@db)
    render_template(@action)
end

def easy_list()
    @items = Terminal.find_all(@db)
    render_template(@action)
end

  def edit()
    if @cgi.params.has_key?('is_commit')
      params = filter_for_params()
      if params.has_key?('id') and params['id'][0] != ''
        @item = Terminal.find_first(@db, params['id'][0])
        @header = 'Редактирование информации об терминале'
        @message = 'Информация об терминале записана'
        if @item.nil?
          @item = Terminal.new
          @header = 'Внесение новой информации об терминале'
          @message = 'Информация о новой терминала внесена в БД'
        end
      else
        @item = Terminal.new
        @header = 'Внесение новой информации об терминале'
        @message = 'Информация о новой терминале внесена в БД'
      end
      params.each do |k, v|
        @item[k] = v[0] if k != 'id' and v != '' and k!='code'
      end
      @item.save(@db)
    else
      if @cgi.params.has_key?('id')
        @item = Terminal.find_first(@db, @cgi.params['id'][0])
        @header = 'Редактирование информации об терминале'
        if @item.nil?
          @item = Terminal.new
          @header = 'Внесение новой информации об терминале'
        end
      else
        @item = Terminal.new
        @header = 'Внесение новой информации об терминале'
      end
    end
    render_template('edit')
  end

 def destroy()
    if @cgi.params.has_key?('id') and @cgi.params['id'][0] != ''
      @item = Terminal.find_first(@db, @cgi.params['id'][0])
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

