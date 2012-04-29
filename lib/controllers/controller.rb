# coding: UTF-8
require 'cgi'
require 'cgi/session'
require 'cgi/session/pstore'
require 'convertors'
require 'db_core/db_driver'
require 'rubygems'
require 'controllers/helper'

# Подключение всех db_core/models/*.rb
Dir[File.join(File.dirname(__FILE__), '..', 'db_core', 'models', "*.rb")].each do |f|
  require(f)
end

class Controller
  include Helper

  DEFAULT_CONTROLLER = :Flights
  DEFAULT_ACTION = :list

  # Список всех контроллеров
  def Controller.all_controllers()
    Dir[File.join(File.dirname(__FILE__), '', "*.rb")].select do |f|
      File.basename(f) != 'controller.rb'
    end.map{ |f| Convertors.controller_file_to_class_name(f) }
  end

  # Методы, выполняющиеся до запуска основного действия
  def before_filters
    [:session, :set_action, :auth, :login_link, :menu]
  end

  # Методы, выполняющиеся после генерации осноного действия
  def after_filters
    [:save_session]
  end

  # Создание и/или подключение к сессии
  def session()
    @cgi = CGI.new('html4') if @cgi.nil?
    @session = CGI::Session.new(@cgi,
     'database_manager' => CGI::Session::PStore,
     'session_key' => '_aero_sess_id',
     'session_expires' => Time.now + 5 * 60,
     'prefix' => 'pstore_aero_sid_') if @session.nil?
  end

  # Закрытие сессии
  def save_session()
    @session.close() unless @session.nil?
  end

  # Проверка прав доступа и, если нужно, перенаправление на ввод пароля
  def auth()
    if !@session['user'].nil? and @session['user'] != ''
      @user = @session['user']
    elsif @cgi.params.has_key?('user') and @cgi.params['user'][0] != '' and
      @cgi.params.has_key?('password') and @cgi.params['password'][0] != ''
      if User.check_user(@db, @cgi.params['user'][0], @cgi.params['password'][0])
        @user = @cgi.params['user'][0]
        @session['user'] = @user
      else
        @action = :login
        @controller = :Auth
      end
   elsif !self.is_authorized_action?
      @user = nil
   else
      @action = :login
      @controller = :Auth
    end
  end

  # Формирование ссылки в левом верхнем углу Вход/Выход
  def login_link()
    if @controller == :Auth
      @login_link_html = '&nbsp;'
    elsif !@user.nil?
      @login_link_html = render_layout('logout_link')
    else
      @login_link_html = render_layout('login_link')
    end
  end

  # Формирование меню
  def menu()
    @menu = Controller.all_controllers.map do |c|
      eval(c + 'Controller').actions(@user).map do |a|
        "<li><a href = 'aero.rb?controller=#{c.to_s}&action=#{a[0]}'>#{a[1]}</a></li>"
      end.join("\n")
    end.join("\n")
    @menu = '<ul>' + @menu + '</ul>' unless @menu == ''
  end

  # Метод, отвечающий требует ли данный запрос доступа по паролю или нет
  def is_authorized_action?()
    return true
  end

  # Установка значение controller/action
  def set_action()
    params = @cgi.params
    @action = params['action'][0].to_sym if @action.nil?
    @controller = (params.has_key?('controller') ?
                    params['controller'][0].to_sym : 
                    self.class.to_sym) if @controller.nil?
  end

  # Проверяет где искать метод (в текущем контроллере или нет)
  def my_action?()
    return @controller.to_s + 'Controller' == self.class.to_s
  end

  # Формирование html документа
  def response()
    render_layout('header', :rb) +
    @html +
    render_layout('footer', :rb)
  end

  # Формирование только содержимого тела html документа
  def response_withot_layout()
    @html
  end

  # Конструктор
  def initialize(cgi = nil, session = nil, action = nil, controller = nil)
    @action = action
    @controller = controller
    @db = DbDriver.instance()
    @cgi = cgi unless cgi.nil?
    @session = session unless session.nil?

    before_filters().each{ |f| self.send(f.to_s) }

    if my_action?()
      @html = self.send(@action.to_s)
    else
      c = eval(@controller.to_s + 'Controller').new(@cgi, @session, @action,
                                                    @controller)
      @html = c.response_withot_layout()
    end

    after_filters().each{ |f| self.send(f.to_s) }
    DbDriver.close()
  end

  # Загружает html-код из файла в строку
  def render_template(name, mode = :rb)
    if mode == :rb
      f = File.new("templates/#{Convertors.class_name_to_controller_dir(@controller)}/#{name}.rb")
      html = eval(f.read)
      f.close
      return html
    else
      f = File.new("templates/#{@controller}/#{name}")
      html = f.read
      f.close
      return html
    end
  end

  # Загружает html-код из файла, лежащего в папке layout, в строку
  def render_layout(name, mode = :html)
    if mode == :rb
      f = File.new("templates/layout/#{name}.rb")
      html = eval(f.read)
      f.close
      return html
    else
      f = File.new("templates/layout/#{name}.html")
      html = f.read
      f.close
      return html
    end
  end

  # Возвращает списки элементов меню
  def Controller.actions(user)
    []
  end

  # Выбирает из параметров только параметры с именем вида: prefix[имя]
  def filter_for_params(prefix = 'item')
    keys = @cgi.params.keys.select{ |k| k =~ /^#{prefix}/ }.map do
      |k| k.gsub(/^#{prefix}\[(.*)\]$/, '\1')
    end
    params = {}
    keys.each{ |k| params[k] = @cgi.params["#{prefix}[#{k}]"] }
    return params
  end
end

# Подключение всех *_controller.rb
Dir[File.join(File.dirname(__FILE__), '', "*.rb")].each do |f|
  require f if File.basename(f) != 'controller.rb'
end

