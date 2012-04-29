"
<form name = 'aero' action = 'aero.rb' method = 'post'>
<input type = 'hidden' name = 'controller' value = 'Flights'>
<input type = 'hidden' name = 'action' value = 'edit'>
<input type = 'hidden' name = 'is_commit' value = 'true'>
<input type = 'hidden' name = 'item[id]' value = '#{@item[:id]}'>
<table class = 'list'>
  <caption>
    #{@header}<br>
    <span style = 'color: Red;'>#{@message}</span>
  </caption>
  <thead>
  <tbody>
    <tr>
      <th>Номер рейса:</th>
      <td><input type = 'text' name = 'item[code]' value = '#{@item[:code]}'></td>
    </tr>
    <tr>
      <th>
        Вылет<br>
        <div style = 'margin-left: 10px;'>город:</div>
        <div style = 'margin-left: 10px;'>время:</div>
        <div style = 'margin-left: 10px;'>аэропорт:</div>
      </th>
      <td>
        &nbsp;<br>
        <input type = 'text' name = 'item[departure_place]' value = '#{@item[:departure_place]}' size = '30'><br>
        <input type = 'text' name = 'item[departure_date]' value = '#{@item[:departure_date]}' size = '30'><br>
        <input type = 'text' name = 'item[departure_airport]' value = '#{@item[:departure_airport]}' size = '30'>
      </td>
    </tr>
    <tr>
      <th>
        Посадка<br>
        <div style = 'margin-left: 10px;'>город:</div>
        <div style = 'margin-left: 10px;'>время:</div>
        <div style = 'margin-left: 10px;'>аэропорт:</div>
      </th>
      <td>
        &nbsp;<br>
        <input type = 'text' name = 'item[arrival_place]' value = '#{@item[:arrival_place]}' size = '30'><br>
        <input type = 'text' name = 'item[arrival_date]' value = '#{@item[:arrival_date]}' size = '30'><br>
        <input type = 'text' name = 'item[arrival_airport]' value = '#{@item[:arrival_airport]}' size = '30'><br>
      </td>
    </tr>
    <tr>
      <th>Авиакомпания:</th>
      <td>#{companies_select('item[company_id]', "#{@item[:company_id]}")}</td>
    </tr>
    <tr>
      <th>Каким рейс является для нашего аэропорта:</th>
      <td>#{is_departure_select('item[is_departure]', "#{@item[:is_departure]}")}</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th colspan = '2'>
        <input type = 'submit' value = 'Внести изменения'>
        <input type = 'button' value = 'Назад к списку'
               onclick = 'javascript:document.location=\"aero.rb?controller=Flights&action=list\"'>
      </th>
    </tr>
  </tfoot>
</table>
"