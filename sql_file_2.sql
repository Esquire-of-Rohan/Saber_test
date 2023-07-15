-- Ход мыслей и действий:

-- 1)В первой CTE таблице нумерую все статусы для каждой задачи отдельно, при этом сортируя от меньшего
-- к большему по полю started_at. Хочу посмотреть статус задачи, где row_number = max(row_number), так как
-- max(row_number) для каждой задачи соответсвует последнему статусу задачи
-- Милисекунды перевожу в секунды, так как unixepoch ожидает секунды в качестве аргумента

-- 2)Во второй CTE таблице смотрю максимальное значение индекса строки в разрезе каждой задачи. Оставляю
-- только те значения,  статус которых не равен "Closed" или  "Resolved"

-- 3)В select statement через left join соединяю две таблицы и подтягиваю только те строки, в которых номер строки
-- из таблицы main_table равен максимальному номеру строки. То есть статус у задачи конечный
-- Поскольку все закрытые задачи исключаются на этапе определения calc_table, то запрос выдает только задачи,
-- конечный статус которых соответствует статусу "незакрыта"

-- "Оформите запрос таким образом, чтобы, изменив дату, 
--его можно было использовать для поиска открытых задач в любой момент времени в прошлом"
-- Если честно, то не знаю точно, каким образом интерпретировать эту формулировку. Поэтому ниже написал две версии запроса
-- Первый запрос выводит все незакрытые задачи, которые есть в таблице history
-- Второй запрос выводит все незакрытые задачи, которые есть в таблице history на дату dd-mm-yyyy,
-- нужно лишь изменить дату в where clause

-- Первый

with main_table as (
select *, row_number() over (PARTITION by issue_key order by started_at) as rn
from history),
calc_table as (
select issue_key, status, max(rn) as max_rn
from main_table
group by issue_key
having status not in ('Closed', 'Resolved'))

select main_table.issue_key, main_table.status, 
cast(datetime(main_table.started_at/1000, 'unixepoch') as text) start_date
from main_table left join calc_table on main_table.issue_key = calc_table.issue_key
where rn = max_rn;

--Второй

with main_table as (
select *, row_number() over (PARTITION by issue_key order by started_at) as rn
from history),
calc_table as (
select issue_key, status, max(rn) as max_rn
from main_table
group by issue_key
having status not in ('Closed', 'Resolved'))

select main_table.issue_key, main_table.status, 
cast(datetime(main_table.started_at/1000, 'unixepoch') as text) start_date
from main_table left join calc_table on main_table.issue_key = calc_table.issue_key
where rn = max_rn and strftime('%d-%m-%Y',datetime(main_table.started_at/1000, 'unixepoch')) = '28-12-2022';
