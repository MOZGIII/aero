# coding: UTF-8
count = 0
"
<table class = 'list'>
  <caption>
    Перечень терминалов
  </caption>
  <thead>
    <tr>
      <th>
        Название
      </th>
      <th>
        Автобус
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
      <td>#{i.bus}</td>
      <td>#{i[:description]}</td>
    </tr>
"
end.join("\n") + "
  </tbody>
</table>
"