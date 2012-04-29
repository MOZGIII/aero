# coding: UTF-8
class AuthController < Controller
  def is_authorized_action?()
    return false
  end

  def login()
    if @cgi.params['action'][0] == 'login' and
        @cgi.params['controller'][0] == 'Auth'
      @reverse_action = DEFAULT_ACTION
      @reverse_controller = DEFAULT_CONTROLLER
    else
      @reverse_action = @cgi.params['action'][0]
      @reverse_controller = @cgi.params['controller'][0]
    end
    render_template(@action)
  end

  def logout()
    @session.delete()
    @session = nil
    @reverse_action = DEFAULT_ACTION
    @reverse_controller = DEFAULT_CONTROLLER
    render_template(@action)
  end
end
