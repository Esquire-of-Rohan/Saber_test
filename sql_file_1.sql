-- Если честно, то я не увидел подвоха в задаче, поэтому написал так, как ниже
-- Подвох может быть в фразе "Задача может переходить в один и тот же статус несколько раз", но на мой взгляд
-- это относится больше ко второй задаче. Конечно, задача может находится >2 раз со статусом open, но я не вижу
-- причин ограничивать количество наблюдений одной и той же задачи со статусом 'Open' 

-- C помощью substr выбираю только первый символ - то бишь группу - из номера задачи
-- Через функцию avg считаю среднее значение минут, в течении которых задача находится в определнном статусе
-- Потом перевожу часы, поделив на 60 и округляю до двух значений с помощью round
-- С помощью where отбираю только задачи со статусом 'Open'
-- Группирую по группе :)

select substr(issue_key,1,1) as groupped, round(avg(minutes_in_status)/60,2) avg_hours
from history
where status = 'Open'
group by groupped