count = 0
"
<table class = 'list'>
  <caption>
    <a href = 'aero.rb?controller=#{@controller}&action=edit'>Создать новую запись</a>
  </caption>
  <thead>
    <tr>
      <th>
        Номер рейса
      </th>
      <th>
        Вылет
      </th>
      <th>
        Посадка
      </th>
      <th>
        Авиакомпания
      </th>
      <th>
        Действия
      </th>
    </tr>
  </thead>
  <tbody>
" + @items.map do |i|
      count += 1
"
    <tr class = 'list#{count % 2}'>
      <td>#{i[:code]}</td>
      <td>#{i[:departure_place]}, #{i[:departure_airport]}: #{i[:departure_date]}</td>
      <td>#{i[:arrival_place]}, #{i[:arrival_airport]}: #{i[:arrival_date]}</td>
      <td>#{i.company_name()}</td>
      <td>
        <a href = 'aero.rb?controller=#{@controller}&action=edit&id=#{i[:id]}'>Редактировать</a>
        <a href = 'aero.rb?controller=#{@controller}&action=destroy&id=#{i[:id]}'>Удалить</a>
      </td>
    </tr>
"
end.join("\n") + "
  </tbody>
</table>
"