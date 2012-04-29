# coding: UTF-8
"
<form name = 'auth' method = 'post' action = 'aero.rb'>
  <input type = 'hidden' name = 'action' value = '#{@reverse_action.to_s}'>
  <input type = 'hidden' name = 'controller' value = '#{@reverse_controller.to_s}'>
" + (@cgi.params.keys - ['controller', 'action']).map do |k|
  @cgi.params[k].map do |i|
    "<input type = 'hidden' name = '#{k}' value = '#{i}'>"
  end.join("\n")
end.join("\n") +
"
  <table class = 'list'>
    <tbody>
      <tr>
        <th>Пользовательское имя:</th>
        <td><input type = 'text' name = 'user' value = ''></td>
      </tr>
      <tr>
        <th>Пароль:</th>
        <td><input type = 'password' name = 'password' value = ''></td>
      </tr>
      <tr>
        <th colspan = '2'><input type = 'submit' value = 'войти'></th>
      </tr>
    </tbody>
  </table>
</form>
"
