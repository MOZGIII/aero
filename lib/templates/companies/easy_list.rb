# coding: UTF-8
count = 0
"
<table class = 'list'>
  <caption>
    Перечень авиакомпаний
  </caption>
  <thead>
    <tr>
      <th>
        Название
      </th>
      <th>
        Код
      </th>
      <th>
        Описание
      </th>
    </tr>
  </thead>
  <tbody>
" + @items.map do |i|
      count += 1
"
    <tr class = 'list#{count % 2}'>
      <td>#{i[:name]}</tdi>
      <td>#{i[:code]}</td>
      <td>#{i[:description]}</td>
    </tr>
"
end.join("\n") + "
  </tbody>
</table>
"