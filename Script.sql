--=====Простая выборка (по одной таблице)=====--
--1.	Выдать список механиков (все столбцы таблицы mechanic). Ответ: 24 строки, 5 столбцов. Запрос: 
select * 
from mechanic m;

--2.	Выдать государственные номерные знаки, серии, номера и даты выдачи свидетельств о регистрации
--транспортных средств (таблица vehicle). Ответ: 161 строка, 4 столбца. Запрос:
select gnz, "ser$reg_certif" , "num$reg_certif" , "date$reg_certif"  
from vehicle v ;

--3.	Сформировать список автомобилей, прошедших обслуживание (таблица maintenance), путем указания 
--их государственных номерных знаков (без дублика-тов). Ответ: 159 строк (без дубликатов), 1 столбец.
select distinct gnz
from maintenance m ;

-- 4.	Выдать список государственных номерных знаков, серии, номера и даты выдачи свидетельств о 
--регистрации транспортных средств в виде таблицы из двух колонок – "Государственный номерной знак", 
--"Свидетельство о регистрации транспортного средства". Ответ: 161 строка, 2 столбца.
select gnz as "Государственный номерной знак", concat("ser$reg_certif" , ' ', "num$reg_certif",
' ' , "date$reg_certif") as "Свидетельство о регистрации"
from vehicle v ;

--5.	Сформировать список автомобильных заводов с указанием наименования, адреса фактического 
--размещения и контактного телефона. Перечень должен быть отсортирован по наименованию, по алфавиту. 
--Ответ: 22 строки, 3 столбца.
select factory_name , legal_addr , phone 
from factory f 
order by 1;

--6.	Составить список групп транспортных средств (таблица transpgroup) в формате 
--<идентификатор группы>: <наименование группы> - <описание> (колонки id_tg, name и note, соответственно). 
--Результирующий столбец должен быть именован, как "Группы транспортных средств". 
--Ответ: 14 строк, 1 столбец.
select concat(id_tg, ': ', "name", ' - ', note)as "Группы транспортных средств"
from transpgroup t;

--7.	Составить список автомобилей с указанием их государственного номерного знака, стоимости и 
--уплаченной суммы налога на добавленную стоимость, которая рас-считывается по ставке 20%. 
--Ответ: 161 строка, 3 столбца. 
--Если посчитать итоговую сумму налогов, то долж-но получиться 73 750 058 руб. 00 коп.
select gnz , "cost" , "cost" * 0.2 as "налог"
from vehicle v;

-- Проверка: 
--select sum("cost" * 0.2)
--from vehicle v; 

--8.	Рассчитать суммарную стоимость зарегистрированных автомобилей. Результат представить в 
--денежном формате (длина мантиссы равна 2). Ответ: 368 750 290.00.
select sum("cost")
from vehicle v; -- int

--9.	Выдать фамилии, инициалы и дату рождения механиков (получить в результирующей выборке один 
--столбец со значениями вида "Светлов В.К., дата рождения 01.06.1967"). Для форматирования дат 
--рождения использовать маску dd.mm.yyyy. Дать столбцу альтернативное имя "Лучшие механики предприятия". 
--Ограничить список первыми пятью механиками, сортировку не производить. Ответ: 5 строк, 1 столбец.  
--Пример записи в ответе: Савостьянов А.В., дата рождения 23.03.1970
select concat(sname_initials, ', дата рождения ', to_char(born, 'dd.mm.yyyy')) as "Лучшие механики предприятия"
from mechanic m 
limit 5;

--10.	 Выдать фамилии, инициалы, даты рождения в формате 'dd.mm.yyyy' и возраст (в полных годах) 
--механиков (использовать встроенную функцию age для работы с интервалами дат; выражение вида 
--trunc((current_date-born)/365) некорректно, так как оно не учитывает високосные года). 
--Ответ: 24 строки, 3 столбца. Если посчитать, 
--сколько лет прожили все механики, то должно получиться 1088 года.

select sname_initials, to_char(born, 'dd.mm.yyyy'), date_part('year', age(born)) 
from mechanic m ;

select sum(date_part('year', age(born))) -- 1095 
from mechanic m ;


--11.	 Рассчитать отношение стоимости каждого автомобиля к его пробегу в километрах с точностью 
--до копейки. Результат представить в виде: "<государственный номер-ной знак>-<значение отношения
-- стоимости к пробегу> руб/км". Ответ: 161 строка, 1 столбец.
select concat(gnz, ' - ', ("cost"/run)::numeric(10,2) , ' руб/км') 
from vehicle v ;

--12.	 Сформировать список автомобилей (государственный номерной знак) с указанием в отдельном 
--столбце даты, а в отдельном столбце времени прохождения обслужи-вания (таблица maintenance). 
--Ответ: 637 строк, 3 столбца.
select gnz, to_char(date_work, 'dd.mm.yyyy') as "Date", to_char(date_work,'hh.mi.ss')  as "Time"
from maintenance m ;

--13.	 Сформировать ведомость амортизационной стоимости автомобилей, учитывая, что за каждый полный 
--год объект учета теряет 7% первоначальной стоимости. Для автомобилей, амортизационная стоимость 
--которых меньше нуля, указывать отрицательную величину. Возраст автомобиля считать от даты ввода 
--в эксплуатацию – date_use (таблица vehicle). В ведомость включить государственные номерные знаки, 
--дату ввода в эксплуатацию и остаточную стоимость. Ответ: 161 строка, 3 столбца.
select gnz as "номерной знак", date_use as "дата ввода в эксплуатацию",
cost - date_part('year', age(date_use))*(cost*0.07) as "остаточная стоимость"
from vehicle v ;

--14.	 Сформировать список автомобилей с указанием дня недели и порядкового дня года, в который 
--они выпущены (столбец date_made таблицы vehicle). Результат оформить в виде одного столбца 
--с именем "День недели и день года выпуска". Ответ: 161 строка, 1 столбец. 
select concat(gnz, ' - ', to_char(date_made, 'day'), ' ', extract(day from date_made)) as "День недели и день года выпуска"
from vehicle v ;

--======Отбоp по условию и сортировка (по одной таблице)=====--

--15.	 Найти российские автомобильные заводы, у которых почтовый и фактический ад-реса совпадают. 
--Сформировать список с именами, фактическими адресами и кон-тактными телефонами предприятий. 
--Ответ: 2 строки, 3 столбца. 

select factory_name , legal_addr , phone 
from factory f 
where legal_addr = post_addr and legal_addr ilike '%РОССИЯ%';


--16.	 Составить список механиков, имеющих трудовой стаж (столбец certif_date) более 13 лет. 
--Выдать фамилии и инициалы механиков, даты выдачи сертификатов и приема на работу, трудовой стаж 
--(полных лет), отсортировать список по возрастанию трудового стажа. 
--Ответ: 15 строк (для запроса в 2022 году), 4 столбца.
select sname_initials , certif_date , work_in_date , date_part('year', age(certif_date))
from mechanic m 
where date_part('year', age(certif_date)) > 13
order by 4 desc;

--17.	 Найти автомобили, для которых НДС, уплаченный при приобретении, превосходит 600 000 рублей 
--(НДС рассчитывается по ставке 20% от суммы платежа). Выдать государственные номерные знаки, суммы 
--и даты поступления уплаченного НДС. Выдачу отсортировать по уменьшению суммы уплаченного НДС. 
--Ответ: 32 строки, 3 столбца. Расчет суммы налогов дает значение 48 026 666 руб. 00 коп.
select gnz, cost * 0.2 as "НДС", "date$reg_certif"  
from vehicle v 
where cost * 0.2 > 600000
order by cost * 0.2 desc;

--select sum(cost * 0.2) --48 026 666
--from vehicle v 
--where cost * 0.2 > 600000

--18.	 Сформировать список автомобилей, зарегистрированных в Орловской области. Вывести 
--государственный номерной знак, серию, номер и дату выдачи свидетельства о регистрации транспортного
-- средства. Отсортировать данные по региону регистрации, по убыванию. Ответ: 146 строк, 4 столбца. 
--В запросе следует учесть, что код региона Орловской области может быть любым из множества {57,  157, 757}.
select gnz, "ser$reg_certif", "num$reg_certif" , "date$reg_certif" 
from vehicle v 
where gnz like '%57 ' 
order by right(gnz,2) desc;


--19.	 Найти работы, выполненные в выходные дни (субботу и воскресенье). Выдать государственные 
--номерные знаки автомобилей, даты проведения работ, дни недели, в которые они проводились, 
--и технические заключения по их результатам (tech_cond_resume). Ответ: 182 строки, 4 столбца. 
--96 работ проведено в воскресенье, остальные – в субботу.
select gnz, date_work , to_char(date_work , 'day'), tech_cond_resume
from maintenance m 
where to_char(date_work , 'day') like 'sunday%' or to_char(date_work , 'day') like 'saturday%' ;

--select count(*) --87
--from (
--select gnz, date_work , to_char(date_work , 'day'), tech_cond_resume
--from maintenance m 
--where to_char(date_work , 'day') like 'sunday%' or to_char(date_work , 'day') like 'saturday%' 
--) t
--where t.to_char like 'saturday%'


--20.	 Сформировать список работ, проведенных в выходные дни (кроме праздничных), по которым 
--не сформировано техническое заключение специалиста. Ответ: 14 строк, 4 столбца.
select gnz, date_work , to_char(date_work , 'day'), tech_cond_resume
from maintenance m 
where to_char(date_work , 'day') not like 's%' and tech_cond_resume is null;


--21.	 Найти наименования отечественных моделей автомобилей, сформированных в соответствие с 
--советским ГОСТ классификации и кодирования (кодировка номера модели имеет четыре разряда). 
--Ответ: 21 строка, 1 столбец.
select model_name 
from model m 
where model_name like '___-____';

--22.	 Выдать фамилии, инициалы механиков с фамилиями, начинающимися на буквы "А", "Ч", "Г" 
--с упорядочением результирующей выборки по фамилии. Ответ: 4 строки 
--(по одному на каждую букву "А" и "Ч", двое – на букву "Г"), 1 столбец.
select sname_initials 
from mechanic m 
where sname_initials like 'А%' or sname_initials like 'Ч%' or sname_initials like 'Г%';

--23.	 Найти автомобильные заводы, в названиях или почтовых адресах или фактических адресах 
--которых встречается символ подчеркивания "_" (использовать предикат LIKE с конструкцией ESCAPE). 
--Выдать названия юридических лиц, их почтовые и фактические адреса и телефоны. 
--Ответ: 1 строки, 4 столбца. Предприятие "Bavarischen motorwerke ainth"
select factory_name , post_addr , legal_addr , phone 
from factory f 
where post_addr like '%$_%' escape '$' or legal_addr like '%$_%' escape '$';

--24.	 Определить, когда последний раз проводилось обслуживание автомобиля с государственным 
--номерным знаком 'c910ca57'. Результат представить в виде даты в формате "день.месяц.год" 
--с указание тысячелетия (четырехразрядное обозначение года). Ответ: 28.01.2019.
select to_char(max(date_work::date), 'dd.mm.yyyy')
from maintenance m 
where gnz = 'c910ca57';

--25.	 Определить автомобили, которые в 2018 году посетили предприятие для обслуживания или ремонта. 
--Ответ: 158 строк, 1 столбец.
select gnz
from maintenance m 
where date_trunc('year', date_work::date) = '2018-01-01';
 

--26.	 Найти технические заключения, серия которых состоит только из цифр. Выдать серии, номера 
--заключений и даты выполнения работ. Ответ: 30 строк, 3 столбца.
select "s$diag_chart" , "n$diag_chart" , date_work 
from maintenance m 
where "s$diag_chart" ~ '^[0-9]{4}';

--27.	 Найти технические заключения о проведенных работах, которые в серии имеют буквосочетание "ТО"
-- в любом регистре, на любой позиции, выданные на работы, проведенные в 2019 году. Выдать серии и 
--номера технических заключений через пробел в одном столбце. Ответ: 96 строк, 1 столбец.
select concat("s$diag_chart" , ' ', "n$diag_chart") 
from maintenance m 
where "s$diag_chart" ilike '%ТО%' and date_trunc('year', date_work::date) = '2019-01-01';

--28.	 Найти работы, выполненные в последний день месяца (учитывать високосные годы). Выдать серии 
--и номера технических заключений, даты (без указания времени) проведения работ, содержание заключения. 
--Ответ: 19 строк, 4 столбца.
select "s$diag_chart" , "n$diag_chart" , to_char(date_work,'dd.mm.yyyy') , tech_cond_resume
from maintenance m 
where to_char(date_work,'dd.mm.yyyy') = to_char((date_trunc('month', date_work) + interval '1 month -1 day')::timestamp(0),'dd.mm.yyyy');

--29.	 Найти автомобили, зарегистрированные за пределами Орловской области (код региона 
--государственного номерного знака не входит во множество {57, 157, 757}). Выдать государственные 
--номерные знаки, даты изготовления, даты начала эксплуатации, серии, номера и даты выдачи 
--свидетельств о регистрации транспортных средств. Результат отсортировать по дате начала 
--эксплуатации. Ответ: 15 строк, 6 столбцов.
select gnz , date_made , date_use , "ser$reg_certif" , "num$reg_certif" , "date$reg_certif" 
from vehicle v 
where gnz not like '%57 ';

--30.	 Сформировать сортированный список государственных номерных знаков зарегистрированных 
--автомобилей с добавлением столбца с порядковым номером записи, с названием "numrow".
--Ответ: 161 строка, 2 столбца.
select gnz, row_number () over() as "numrow"
from vehicle v ;

--=====Выборка из нескольких таблиц=====--

--31.	 Сформировать список производителей автомобилей и принадлежащих им заводов, отсортированный 
--по столбцу "Производитель" по алфавиту. Столбец с названиями заводов именовать как "Завод".
--Ответ: 22 строки,  2 столбца.
select b."name" as "Производитель" , f.factory_name as "Завод"
from brand b 
join factory f on f.idb = b.idb 
order by 1

--32.	 Составить список автомобилей с указанием их государственного номерного знака (таблица 
--vehicle), производителя (таблица brand), наименования марки (таблица marka) и модели (таблица model). 
--Выдачу сформировать в виде двух столбцов – "Государственный номерной знак" и "Автомобиль". Во 
--втором столбце должны быть через запятую указаны производитель, марка и модель. Учесть, что при 
--конкатенации строк если одно из выражений возвращает NULL, то и вся строка примет значение NULL 
--(использовать функцию COALESCE). Ответ: 161 строка, 2 столбца.
select gnz as "Государственный номерной знак", 
concat(b."name", ', ', m1."name", ', ', m2.model_name) as "Автомобиль"
from vehicle v 
join brand b on b.idb = v.idb
join marka m1 on m1.idm = v.idm 
join model m2 on m2.idmo = v.idmo


--33.	 Создать список контактных телефонов производителей (телефоны заводов), по которым могут 
--обратиться владельцы автомобилей. Указать государственный номерной знак автомобиля, наименование 
--производителя и контактный телефон завода, на котором произведен автомобиль. 
--Ответ: 161 строка, 3 столбца.
select gnz , b."name" , b.phone 
from vehicle v 
join brand b on b.idb = v.idb

--34.	 Составить список механиков, обслуживавших автомобиль с государственным номерным знаком 
--"o009oo57". В выдачу включить дату проведения работ в формате "dd.mm.yyyy" и фамилию и инициалы 
--механика. Результат отсортировать в хронологическом порядке. Ответ: 13 строк, 2 столбца.
select m.date_work::date , m2.sname_initials 
from maintenance m 
join mechanic m2 on m2.id_mech = m.id_mech 
where gnz like 'o009oo57 '
order by 1


--35.	 Найти автомобили производства Японии. Указать производителя, марку, модель, разделенные 
--пробелами в одном столбце, и государственный номерной знак. Учесть, что ряд автомобилей в атрибуте 
--marka имеют значение NULL. Ответ: 22 строки, 2 столбца.
select concat(b."name", ', ', m1."name", ', ', m2.model_name) as "Автомобиль", gnz
from vehicle v 
join brand b on b.idb = v.idb
join marka m1 on m1.idm = v.idm 
join model m2 on m2.idmo = v.idmo
join state s on s.st_id = v.st_id 
where v.st_id =(select st_id from state s where "name" = 'Япония')

--36.	 Сформировать список автомобилей, сменивших владельца (самосоединение таблицы vehicle со 
--своей копией, совпадают даты изготовления, производители, марки, модели; различаются государственные
--номерные знаки, серии, номера и даты выдачи свидетельств о регистрации транспортных средств). 
--В выдачу включить столбец "Дата изготовления", указать установленный ранее государственный номерной 
--знак, серию, номер и дату (в формате "dd.mm.yyyy") выдачи свидетельства о регистрации транспортного 
--средства в одном столбце, разделив пробелами. Такие же данные должны быть приведены по новому 
--государственному регистрационному знаку и свидетельству о регистрации транспортного средства 
--(всего в результирующей выборке должно быть 5 столбцов).
--Ответ: один автомобиль (изготовлен 12 июля 2018 года).
select to_char(v.date_made::date, 'dd.mm.yyyy') as "Дата изготовления", v.gnz as "old", 
concat(v."ser$reg_certif" , ' ', v."num$reg_certif" , ' ', to_char(v."date$reg_certif", 'dd.mm.yyyy')) as "Данные" 
, v2.gnz as "new",
concat(v2."ser$reg_certif" , ' ', v2."num$reg_certif" , ' ', to_char(v2."date$reg_certif", 'dd.mm.yyyy')) as "Данные"
from vehicle v 
left join vehicle v2 on v2.date_made = v.date_made and v.gnz < v2.gnz 
where v2.gnz is not null


--37.	 Выдать список механиков (фамилии и инициалы), государственные номерные знаки обслуженных 
--или отремонтированных ими автомобилей и даты выполнения работ с учетом возможности отсутствия 
--выполненных заказов некоторыми механиками (использовать левое внешнее соединение, left outer join). 
--Ответ: 639 строк, 3 столбца. Заказы не выполняли Калатошкин М.П. и Лискунов М.В.
select m.sname_initials , m2.gnz , m2.date_work --644
from mechanic m 
left outer join maintenance m2 on m2.id_mech = m.id_mech 

--38.	 Сформировать список технических заключений по ремонтам автомобилей BMW. В выдачу включить 
--наименование производителя, наименование завода, дату проведения ремонта без указания времени, 
--формулировку технического заключения. Список технических заключений отсортировать по дате 
--оформления. Ответ: 11 строк, 4 столбца.
select b."name" , f.factory_name , m.date_work::date , m.tech_cond_resume 
from maintenance m 
join brand b on b.idb = m.idb 
join factory f on f.idf = m.idf 
where b."name" = 'BMW'
order by m.date_work 

--39.	 Найти автомобильные предприятия, расположенные на той же улице, что и "ОАО АВТОВАЗ". 
--Выдать наименование, почтовый и фактический адрес, контактный телефон. Использовать самосоединение.
--Ответ: Опытный завод специальных автомобилей ОАО АВТОВАЗ.
select f.factory_name , f.post_addr , f.legal_addr , f.phone 
from factory f  
join factory f2 on f2.post_addr = f.post_addr 
where f.factory_name like '%ОАО АВТОВАЗ'

--40.	 Найти автомобили, которые обслуживал тот же механик, что и автомобиль с государственным 
--номерным знаком "o929ao57". Выдать государственные номерные знаки обслуженных автомобилей, 
--даты выполнения работ и в отдельном столбце время выполнения работ в 24-часовом формате без 
--указания секунд. Ответ: 40 строк, 3 столбца.
explain analyze
select gnz, to_char(date_work, 'dd.mm.yyyy') as "data", to_char(date_work, 'hh24.mi') as "time"
from maintenance m 
where id_mech = (select id_mech from maintenance m2 where gnz = 'o929ao57')

--41.	 Сформировать список автомобилей, свидетельство о регистрации транспортного средства которых
--имеет ту же серию, что и документ автомобиля с государственным номерным знаком "c172ac57". 
--В выдачу включить только автомобили того же производителя, что и автомобиль с государственным 
--номерным знаком "c172ac57", указать их государственный номерной знак, наименование производителя, 
--дату ввода в эксплуатацию (date_use). Ответ: 3 строки, 3 столбца. 
--В выдаче не должно быть строки с данными об автомобиле с государственным номерным знаком "c172ac57".
select *
from vehicle v 
where "ser$reg_certif" = (select "ser$reg_certif" from vehicle v2 where gnz = 'c172ac57') and 
idb = (select idb from vehicle v3 where gnz = 'c172ac57') and gnz != 'c172ac57'

--===== Вложенные запросы =====--

---42.	 Найти автомобили, которые никогда не обслуживались предприятием. Выдать список государственных 
--номерных знаков этих автомобилей. Ответ: 2 строки, 1 столбец. Автомобили "c519op57"и "a333aa57".
select gnz 
from vehicle
where gnz not in (select gnz from maintenance)

--43.	 Составить список автомобилей (государственный номерной знак и стоимость), которые стоят 
--не более средней стоимости всех зарегистрированных автомобилей. Ответ: 111 строк, 2 столбца. 
--Сумма стоимости найденных автомобилей 83 170 150 руб. 00 коп.
select gnz, "cost" 
from vehicle v 
where "cost" < (select avg(v2.cost) from vehicle v2 )

select gnz 
from vehicle
where gnz Not in (select gnz from maintenance)


--44.	 Найти автомобили, которые были приобретены не новыми. К таким можно отнести экземпляры, у 
--которых год и месяц начала эксплуатации и год и месяц даты выдачи свидетельства о регистрации 
--транспортного средства не совпадают. Ответ: 76 автомобилей, 
--один из которых имеет государственный номерной знак "o002oo57".
select gnz 
from vehicle v 
where to_char(date_use,'mm.yyyy') != to_char(date$reg_certif,'mm.yyyy')


--45.	 Найти автомобили, изготовленные на том же заводе, что и автомобиль с государственным номерным 
--знаком "x027kp57". Выдать их государственные номерные знаки, наименование, почтовый адрес и 
--контактный телефон завода. 
--Ответ: автомобиль с государственным номерным знаком "c014xp57", изготовленный на заводе BMW в Австрии.
select v.gnz, f.factory_name, f.post_addr, f.phone 
from vehicle v 
join factory f on f.idf = v.idf 
where v.idf in (select idf from vehicle where gnz = 'x027kp57') and 
f.idf in (select idf from vehicle where gnz = 'x027kp57') 
and v.gnz!= 'x027kp57'

--46.	 Составить список автомобильных брендов, не имеющих собственного производства на территории 
--Российской Федерации. Указать их наименования, государственную принадлежность.
--Ответ: 7 компаний, три из ФРГ, по две из Франции и Японии.
select distinct f.idb , b."name" , s2."name" 
from factory f 
join brand b on b.idb = f.idb 
join state s2 on s2.st_id = f.st_id 
where f.st_id != (select s.st_id from state s
	where s."name" like 'Российская Федерация')

--47.	 Найти производителей, которые имеют заводы, как на территории Российской Федерации, так и 
--за ее пределами. Указать наименование бренда, название и адрес размещения завода.
--Ответ: производители "BMW" и "Mercedes-Benz". Всего 6 строк.

--48.	 Определить почтовый адрес завода, изготовившего автомобиль с государственным номерным знаком 
--"a723ak57", для направления претензии по недостатку, выявленному в ходе проведения ремонта 
--6 ноября 2018 года. В выдачу включить государственный номерной знак, производителя, марку и модель 
--автомобиля в одной колонке через запятую, дату изготовления автомобиля, наименование 
--завода-изготовителя, его почтовый адрес, дату проведения ремонта, серию и номер выданной 
--диагностической карты в одной колонке через пробел, техническое заключение по ремонту.
--Ответ: 1 строка, 8 столбцов.

--49.	 Рассчитать количество заказов по видам работ. Выдачу сформировать в виде таблицы, 
--где предусмотреть три столбца: "Техническое обслуживание", включив в подсчет все виды технического 
--обслуживания: "Ремонт"; "Предпродажная подготовка". 
--Ответ: 413 ТО, 138 ремонтов, 86 предпродажных подготовок.

--50.	 Найти механиков, которые выполнили 2 и более заказов в один день. Выдать их фамилии и 
--инициалы. Ответ: 8 механиков, один из которых Слепцов П.Н.


--===== Теоретико-множественные операции =====--

--51.	 Найти автомобили, претендующие на отнесение к классу раритетных. К таковым относят автомобили
--отечественного производства в возрасте не менее 30 лет, либо зарубежные автомобили в возрасте 
--не менее 25 лет, либо автомобили, имеющие пробег не менее 500000 км без учета возраста. Указать 
--государственный номерной знак, год выпуска и пробег каждого из них. Ответ: 4 строки, 3 столбца. 
--Автомобиль с государственным номерным знаком "c945op57" вызывает подозрение о некорректном указании пробега.

--52.	 Найти автомобили, которые посещали предприятие только по пятницам. Выдать государственные 
--номерные знаки. Ответ: 9 автомобилей, один из которых – "c806yc57".

--53.	 Найти все автомобили, обслуженные механиком Баженовым М.К. (все виды ТО), и (в том числе включительно) 
--отремонтированные механиком Савостьяновым А.В. (только ремонты). Указать их государственные номерные знаки.
--Ответ: 1 автомобиль, государственный номерной знак "k857po77".

--54.	 Найти механиков, которые в 2018 году ежемесячно (без пропусков) получали наряды на обслуживание 
--или ремонт автомобилей. Выдать их фамилии и инициалы. Ответ: Голубев Д.Н.

--55.	 Найти автомобили, которые обслуживались только в 2018 году. Указать государственный номерной знак, 
--дату проведения обслуживания и техническое заключение по его результатам. Ответ: 9 строк, 3 столбца.

--56.	 Выдать список рабочих дней в феврале 2018 года, в которые не выполнялись заказы 
--по обслуживанию или ремонту автомобилей. Выдать даты дней без заказов.
--Ответ: 12 дней, в том числе 14 февраля 2018 года.

--===== Агрегирование данных, групповые операции =====--

57.	 Определить количество работ, выполненных в 2017 году. 
Ответ: закрыто 98 заказов.

58.	 Рассчитать общую сумму НДС, уплаченную в 2016 году (НДС рассчитывается как 18% от суммы платежа) за приобретенные автомобили. Результат округлить до ко-пеек и представить в виде количества рублей и копеек. 
Ответ: 7 021 189 руб. 80 коп.

59.	 Определить, сколько учтено автомобилей, зарегистрированных в Орловской обла-сти. 
Ответ: 146 автомобилей.

60.	 Определить средний возраст механиков предприятия с точностью до двух знача-щих цифр мантиссы.
Ответ: по состоянию на ноябрь 2022 года –  42.7 года.

61.	 Определить общую и среднюю стоимость с точностью до копейки, общий и сред-ний пробег с точностью до 100 м всех зарегистрированных автомобилей. Указать в качестве имен столбцов требуемые вычисления.
Ответ: 368 750 290.00, 2 290 374.47, 26 075 702.0, 161 960.8.

62.	 Определить средний пробег автомобилей каждого бренда. Результат округлить до 10 м. 
Ответ: 10 строк, 2 столбца. Средний пробег автомобилей BMW 70937.40 км.

63.	 Рассчитать среднюю стоимость с точностью до копейки каждой марки зарегистри-рованных автомобилей. В выдачу включить наименование бренда, марки и сред-нюю стоимость.
Ответ: 47 строк, 3 столбца.

64.	 Определить с точностью до двух значащих цифр мантиссы средний возраст авто-мобилей каждой марки. Для автомобилей, у которых не предусмотрена марка, ука-зывать модель.
Ответ: 49 строк, 2 столбца.

65.	 Определить год, за который поступило больше всего заказов (относительно дру-гих лет).
Ответ: 2019 год.

66.	 Построить распределение марок автомобилей, ограничив список марками, встре-чающимися не менее 8 раз. Список упорядочить по уменьшению количества эк-земпляров марки.
Ответ: "ГАЗ Газель" (24), "ВАЗ Веста" (16), "BMW Serie 3" (8).

67.	 Найти автомобили, владельцы которых за все время разместили заказ только один раз. Выдать государственные номерные знаки.
Ответ: 35 автомобилей, один из которых "y474kx57".

--===== Совместное использование конструкций языка SQL =====--

68.	 Найти автомобили, выпущенные в Евросоюзе. Выдать государственные номерные знаки, государственную принадлежность и наименование завода-изготовителя, его фактический адрес и телефон.
Ответ: 44 автомобиля из ФРГ и Франции.

69.	 Найти автомобили, которые проходили на предприятии только предпродажную подготовку. Указать их государственные номерные знаки, дату предпродажной подготовки, фамилию и инициалы механика, проводившего работы.
Ответ: 86 автомобилей, один из которых "e346kx57".

70.	 Определить автомобильный бренд, на который клиенты предприятия, вместе по-тратили больше всех денег (найти «автомобиль богатых»).
Ответ: Mercedes-Benz.

71.	 Определить, сколько автобусов обслужено механиком Кротовым К.О.
Ответ: 4 автобуса.

72.	 Найти автомобили, которые были приобретены не новыми (интервал между датой выдачи свидетельства о регистрации транспортного средства и датой начала экс-плуатации больше двух недель). Выдать государственные номерные знаки, произ-водителя, марку, модель, серию, номер и дату выдачи свидетельства о регистрации транспортного средства, дату начала эксплуатации. Все данные, кроме даты начала эксплуатации организовать одним столбцом по формату: <Государственный но-мерной знак><Производитель><Марка><Модель>, Свидетельство о регистрации <Серия СРТС> № <Номер СРТС> выдано: <Дата выдачи СРТС>.
Ответ: 44 автомобиля.

73.	 Сформировать список заводов по производству автомобилей, размещенных на территории Российской Федерации, и, в зависимости от того, входит ли страна бренда в Европейский союз или нет, указать наименование бренда, предприятия, почтовый или фактический адрес соответственно (для стран Евросоюза указывать почтовый адрес), телефон.
Ответ: 7 строк, 4 столбца.

74.	 Найти производителей, автомобили которых в 2018 году реже остальных требова-ли ремонта. Выдать названия брендов и количество ремонтов их автомобилей.
Ответ: "Peugeot" – 2 ремонта.

75.	 Найти механиков, которые выполнили больше работ, чем Голубев Д.Н. В выдачу включить фамилии и инициалы этих людей.
Ответ: семь механиков, один из которых – Лосев П.Л.

76.	 Найти автомобили, зарегистрированные в один и тот же день. Выдать государ-ственные номерные знаки, в одном столбце через пробел производителя, марку и модель каждого из них, дату регистрации.
Ответ: 24 строки, 3 столбца.

77.	 Для каждого автомобиля указать число посещения им предприятия (учитывать, что могут быть автомобили, которые ни разу не обслуживались, в этом случае вы-водить значение 0). Вывести государственные номерные знаки, серии, номера и да-ты их свидетельств о регистрации транспортного средства и количество посеще-ний. Выдачу отсортировать по количеству посещений.
Ответ: 161 строка, 5 столбцов.

78.	 Найти автомобили, которые в 2016, 2017 и 2018 годах совершили 80% и более посещений предприятия от всего объема их обслуживания за все время. Вывести их государственные номерные знаки. 
Ответ: 22 автомобиля, один из которых – "y777yy57".

79.	 Найти механиков, получивших сертификат на работу после достижения ими пен-сионного возраста. Учесть, что до 2018 года возраст выхода на пенсию для мужчин составлял 60, а для женщин – 55 лет, а с 2018 года эти показатели увеличены на 5 лет и действуют относительно тех, кому настал срок выхода на пенсию. Прогрес-сивную шкалу роста пенсионного возраста не учитывать. Выдать фамилии, иници-алы и даты рождения механиков, даты получения ими сертификатов и приема на работу.
Ответ: два человека (Савостьянова Н.М. и Бекетов А.С.).

80.	 Сформировать отчет о выполненных ремонтах автомобилей за все время работы предприятия. В отчете отобразить: государственный номерной знак; в одном столбце через запятую наименование производителя, марку и модель; также в од-ном столбце указать через пробел серию, номер и дату выдачи свидетельства о ре-гистрации транспортного средства; дату проведения ремонта; фамилию и инициалы механика, выполнившего ремонт; техническое заключение по ремонту. Все даты приводить в формате "dd.mm.yyyy".
Ответ: 997 строк, 6 столбцов. 

81.	 Определить долю в процентах (с точностью до двух значащих цифр мантиссы) в общем результате предприятия механика Савостьянова А.В. Считать, что все рабо-ты (заказы на ремонт или обслуживание) являются одинаково весомыми в общих итогах работы предприятия. 
Ответ:  6,44%.

82.	 Сформировать список инвестиционно не выгодных автомобилей. К таковым отно-сятся автомобили с пробегом не менее 100 000 км, или имеющие возраст 3 и более года, или побывавшие в ремонте хотя бы один раз, а также автомобили из транс-портных групп "Специальные автомобили", "Специализированные автомобили", "Спортивные автомобили" или "Спортивные мотоциклы". В список включить столбцы: "Государственный номерной знак", "Возраст", "Пробег" и "Дата послед-него ремонта". Если автомобиль в ремонте не был, то в последнем столбце должен храниться пробел. 
Ответ: 131 строка, 4 столбца.

83.	 Определить проводилось ли не регламентное техническое обслуживание автомо-билей японского производства. Не регламентным считается любое техническое об-служивание, не предусмотренное для автомобилей, выпущенных японскими про-изводителями. В выдаче указать государственные номерные знаки, производителя, марку, модель автомобиля, вид, дату и заключение по проведенному не регла-ментному ТО, фамилию и инициалы механика, выполнявшего работы.
Ответ: 10 строк, 8 столбцов, два автомобиля с государственными номерными зна-ками "a450ox57" и "k161op57".

--===== Задания повышенной сложности =====--

--84.	 Определить самый не надежный автомобиль, который имеет наименьший интервал 
--между двумя любыми ремонтами. Указать его государственный номерной знак и наименьший 
--интервал между ремонтами в секундах.
--Ответ: автомобиль с государственным номерным знаком "a964oa57". Интервал составляет 
--18720 сек.
select m.gnz, extract(epoch from m.date_work - m2.date_work) as "СЕК"
from maintenance m
join maintenance m2 on m.gnz = m2.gnz and m.date_work != m2.date_work
where extract(epoch from m.date_work - m2.date_work) > 0
group by m.gnz, m.date_work, m2.date_work
order by "СЕК" asc 
limit 1


--85.	 Найти объем убыли клиентов с ростом возраста автомобилей, составив таблицу, 
--где в одном столбце указан номер ТО, а в другом – число выполненных работ соответствующего 
--вида. Данные должны быть отсортированы по номеру и виду ТО, сначала ТО-1. После 
--перечисления всех видов ТО приводятся сведения по ТО для японских автомобилей.
--Ответ: 16 строк, 2 столбца.
with cte1 as(
select mt.name, count(tech_cond_resume)
from maintenance m
join maintenancetype mt on m.mt_id = mt.mt_id 
and mt.name ilike 'то-%'
group by mt.name
order by mt.name asc
)
select cte1.* 
from cte1 where cte1.name not ilike '%то-%япон%'
union all 
select cte1.* 
from cte1
where cte1.name ilike '%то-%япон%'


--86.	 Составить таблицу изменения рентабельности предприятия по годам, где показаны 
--абсолютное число выполненных заказов, относительное число заказов на один 
--зарегистрированный автомобиль (учесть, что после выполнения предпродажной подготовки, 
--автомобиль более не является зарегистрированным, хотя данные о нем сохраняются в 
--базе данных), абсолютный прирост числа заказов, упущенная выгода в виде не добранных 
--процентов если считать за 100% ситуацию, когда все зарегистрированные автомобили 
--прибывают на предприятие один раз в год. Ответ: 25 строк, 4 столбца.

--87.	 Составить "возрастную карту" зарегистрированных автомобилей, включив в нее 
--столбец наименований изготовителей, столбцы для указания доли в процентах, округленной 
--до двух значащих цифр мантиссы, автомобилей в возрасте от 0 до 6 лет, от 7 до 10 лет, 
--от 11 до 13 лет, от 14 до 18 лет и старше 18 лет. Ответ: 10 строк, 6 столбцов.
select b.name, t2.concat as "0-6", t3.concat as "7-10", 
	t4.concat as "11-13", t5.concat as "14-18", t6.concat as ">18"
from brand b
full join
	(select distinct b.name, concat(round((count(b.name)::numeric/temp.count::numeric)*100,2),' %')
	from vehicle v, brand b, (select count(gnz)
							  from vehicle
							  where date_part('year', age(date_use)) < 6) temp
	where date_part('year', age(date_use)) < 6 and v.idb = b.idb
	group by b.name,temp.count) t2
on b.name = t2.name
full join
	(select distinct b.name, concat(round((count(b.name)::numeric/temp.count::numeric)*100,2),' %')
	from vehicle v, brand b,(select count(gnz)
							 from vehicle
							 where date_part('year', age(date_use)) > 6 and date_part('year', age(date_use)) <=10) temp
	where date_part('year', age(date_use)) > 6 and date_part('year', age(date_use)) <=10 and v.idb = b.idb
	group by b.name, temp.count) t3
on b.name = t3.name
full join
	(select distinct b.name, concat(round((count(b.name)::numeric/temp.count::numeric)*100,2),' %')
	from vehicle v, brand b,(select count(gnz)
							 from vehicle
							 where date_part('year', age(date_use)) > 10 and date_part('year', age(date_use)) <=13) temp
	where date_part('year', age(date_use)) > 10 and date_part('year', age(date_use)) <=13 and v.idb = b.idb
	group by b.name, temp.count) t4
on b.name = t4.name
full join
	(select distinct b.name, concat(round((count(b.name)::numeric/temp.count::numeric)*100,2),' %')
	from vehicle v, brand b,(select count(gnz)
							 from vehicle
							 where date_part('year', age(date_use)) > 13 and date_part('year', age(date_use)) <=18) temp
	where date_part('year', age(date_use)) > 13 and date_part('year', age(date_use)) <=18 and v.idb = b.idb
	group by b.name, temp.count) t5
on b.name = t5.name
full join
	(select distinct b.name, concat(round((count(b.name)::numeric/temp.count::numeric)*100,2),' %')
	from vehicle v, brand b,(select count(gnz)
							 from vehicle
							 where date_part('year', age(date_use)) > 18) temp
	where date_part('year', age(date_use)) > 18 and v.idb = b.idb
	group by b.name, temp.count) t6
on b.name = t6.name


--88.	 Определить заводизготовитель, продукция которого больше других требует ремонта 
--(гарантийный срок не учитывать) в абсолютных показателях и завод с наибольшей долей 
--отказов продукции (число ремонтов на один зарегистрированный в базе данных автомобиль). 
--Выдать наименования, принадлежность брендам, страны брендов, почтовые адреса и 
--телефоны (в двух столбцах), количество ремонтов выпущенных ими автомобилей и долю 
--ремонтов на один зарегистрированный автомобиль.
--Ответ: по обоим показателям один и тот же завод "Austria Bavarischen motorwerke" 
--с абсолютным показателем 3 отказа и долей в 0.666667.

--89.	 Найти автомобили с заводским браком (интервал времени между датой регистрации
--и первым ремонтом, не превышающий 1 года). Выдать их государственные номерные знаки; 
--производителя, марку и модель в одном столбце; дату регистрации; дату первого ремонта; 
--интервал в днях от регистрации до первого ремонта.
--Ответ: 3 автомобиля, два NISSAN и один ГАЗ.
with cte as(
select m.gnz , m.date_work , row_number() over(partition by gnz order by date_work::date)
from maintenance m 
join maintenancetype mt on mt.mt_id = m.mt_id  
where mt."name" ilike 'РЕМОНТ'
)
select cte.gnz, concat(b.name,', ', ma.name,', ', mo.model_name) as "Автомобиль",
to_char(v.date$reg_certif, 'dd.mm.yyyy') as "Дата регистрации", 
to_char(cte.date_work, 'dd.mm.yyyy') as "Дата ремонта", 
date_part('day', cte.date_work - v.date$reg_certif) as "Дней до ремонта"
from cte
join vehicle v on cte.gnz = v.gnz 
join brand b on b.idb = v.idb 
join marka ma on ma.idm = v.idm 
join model mo on mo.idmo = v.idmo
where cte.row_number = 1 and date_part('day', cte.date_work - v.date$reg_certif) < 366

--90.	 Найти автомобили, которые в течение одного года обслуживались или ремонтировались 
--только у разных механиков. Выдать их государственные номерные знаки, даты, когда 
--проводилось обслуживание или ремонт, фамилии и инициалы механиков. Учесть, что 
--автомобили, посещавшие предприятие один раз в году, также относятся к обслуженным 
--разными механиками в этом году, отсортировать выдачу по государственным номерным знакам.
--Ответ: 340 строк, 3 столбца.
with cte as(
select m.gnz, mch.id_mech, date_part('year',m.date_work)
from maintenance m
join mechanic mch on mch.id_mech = m.id_mech
)
from maintenance m
join mechanic mch on mch.id_mech = m.id_mech
join cte on cte.gnz = m.gnz
	and date_part('year',m.date_work) = cte.date_part 
	and m.id_mech != cte.id_mech 
group by m.gnz, mch.sname_initials, m.date_work, cte.date_part
order by m.gnz, cte.date_part desc

--91.	 Определить медианное значение и разброс стоимости зарегистрированных автомобилей, 
--считая, что стоимость распределена нормально. Для определения медианного значения 
--стоимости использовать математическое ожидание, рассчитанное, как сумма произведений 
--каждой стоимости на количество ее повторов в ряду стоимостей, деленное на общее число 
--зарегистрированных автомобилей. Разброс рассчитать, как квадратный корень из разности 
--медианы ранжированного ряда квадратов стоимости и квадрата медианы.
--Ответ: медиана – 2 290 301 руб., разброс – 3 932 362 руб.
select sum(trunc((((t."cost" * t.count) / 161)::numeric) , 0))::money as "Медиана" , 
trunc(ceiling((|/(sum(trunc((((t."cost" ^ 2 * t.count) / 161)::numeric), 0)) 
	- sum(trunc((((t."cost" * t.count) / 161)::numeric), 0)) ^ 2)))::numeric, 0)::money 
		as "Разброс"
from (
select v."cost", count(v."cost")
from vehicle v
group by v.cost
) t