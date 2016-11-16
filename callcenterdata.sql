select username,dates,ccuser_id,phone_attempts,phone_connects,inbound,outbound
,Pause_3_mins,Personal_break,Meeting,Training,Quality_feedback,Available,talktime,
to_char(login,'DD/MM/YYYY HH24:MI:SS') as login ,to_char(END_TIME,'DD/MM/YYYY HH24:MI:SS')AS END_TIME 
from((select  date(imc.created + interval'5:30')as dates,ccuser_id as ccuser_ids ,(first_name || ' ' || last_name) as UserName,
count(call_type)as phone_attempts,count(case when status = 'completed' then 1 else null end) as phone_connects, 
to_char(sum(imc.modified -imc.created),'HH24:MI:SS') as talktime ,sum (case when call_type = 1 then 1 else null end) as inbound,sum (case when call_type = 0 then 1 else null end) as outbound  from 
"InteractionManager_callrecord" imc join "Company_callcenter" as ccc on imc.ccuser_id = ccc.id 
 join  auth_user au on ccc.auth_user_id = au.id
 where  date(imc.created + interval'5:30')>=cast(date_trunc('month',current_date)as date) 
group by 1,2,3  order by 2,3 desc )q
left join
(select coalesce (user_id) as user_id,coalesce(date) as date,
to_char(((extract(epoch from (sum(Pause_3_mins))))||' SECOND')::INTERVAL,'HH24:MI:SS') as Pause_3_mins,
to_char(((extract(epoch from (sum(Personal_break))))||' SECOND')::INTERVAL,'HH24:MI:SS')as  Personal_break,
to_char(((extract(epoch from (sum(Meeting))))||' SECOND')::INTERVAL,'HH24:MI:SS')as Meeting,
to_char(((extract(epoch from (sum(Training))))||' SECOND')::INTERVAL,'HH24:MI:SS')as Training,
to_char(((extract(epoch from (sum(Quality_feedback))))||' SECOND')::INTERVAL,'HH24:MI:SS')as Quality_feedback,
to_char(((extract(epoch from (sum(Available))))||' SECOND')::INTERVAL,'HH24:MI:SS')as Available
from( select user_id, date,
case when action = 'P3' then sum(yo) ELSE null END AS Pause_3_mins,
case when action = 'PB' then sum(yo) ELSE null END AS Personal_break,
case when action = 'M' then sum(yo) ELSE null END AS Meeting,
case when action = 'T' then sum(yo) ELSE null END AS Training,
case when action = 'QF' then sum(yo) ELSE null END AS Quality_feedback,
case when action = 'In' then sum(yo) ELSE null END AS Available
from (select (b.yo_time-a.yo_time) as yo ,a.ccuser_id as user_id,a.action,date(created +interval'5:30') as date  
from (SELECT ccua.*,ccua.created+interval'5:30' as yo_time ,
ccua.ccuser_id AS ID,row_number() over(order by  ccua.ccuser_id ,ccua.created )as row_name ,date(created +interval'5:30') as date 
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id 
where  date(created +interval'5:30') >=cast(date_trunc('month',current_date)as date) order by  ccua.ccuser_id ,ccua.created )a
join (SELECT ccua.created+interval'5:30' as yo_time ,row_number() over(order by  ccua.ccuser_id ,ccua.created )- 1 as row_name1 ,date(created +interval'5:30') as date
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id  
where  date(created +interval'5:30') >=cast(date_trunc('month',current_date)as date) order by  ccua.ccuser_id ,ccua.created )b on 
a.row_name = b.row_name1 and a.date = b.date 
where b.yo_time-a.yo_time >= '00:00:00')B 
where action in ('P3','PB','M','T','QF','In')
group by 1,2,action order by 1)a 
group by 1,2)y
on q.ccuser_ids =y.user_id and q.dates = y.date 
left join 
(select ccuser_id,date(created+interval'5:30'),max(created+interval'5:30') as end_time,min (created+interval'5:30')as login from 
 "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id 
 where  date(created +interval'5:30') >=cast(date_trunc('month',current_date)as date)  
 group by 1,2 order by 1,2)z on q.ccuser_ids =z.ccuser_id and q.dates = z.date)x 
 ORDER BY 2,1