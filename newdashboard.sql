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

from (select a.ccuaid ,(case when b.yo_time>a.yo_time then b.yo_time-a.yo_time  else (now()+interval'5:30')-a.yo_time  end  ) as yo,b.yo_time,a.yo_time ,a.ccuser_id as user_id,a.action,date(created +interval'5:30')  
from (SELECT ccua.*,ccua.id as ccuaid  ,ccua.created+interval'5:30' as yo_time ,
ccua.ccuser_id AS ID,row_number() over(order by  ccua.ccuser_id ,ccua.created )as row_name ,date(created +interval'5:30') as date 
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id 
where  date(created +interval'5:30') >='2016-09-01' order by  ccua.ccuser_id ,ccua.created )a
full outer  join (SELECT ccua.created+interval'5:30' as yo_time ,row_number() over(order by  ccua.ccuser_id ,ccua.created )- 1 as row_name1 ,date(created +interval'5:30') as date
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id  
where  date(created +interval'5:30') >='2016-09-01' order by  ccua.ccuser_id ,ccua.created )b
 on  a.row_name = b.row_name1 
order by yo )B 
where action in ('P3','PB','M','T','QF','In')
group by 1,2,action order by 1)a 
group by 1,2)



select a.ccuaid ,(case when b.yo_time>a.yo_time then b.yo_time-a.yo_time  else (now()+interval'5:30')-a.yo_time  end  ) as yo,b.yo_time,a.yo_time ,a.id as user_id,a.action,date(a.yo_time +interval'5:30')  
from (SELECT ccua.id as ccuaid  ,ccua.created+interval'5:30' as yo_time ,action,
ccua.ccuser_id AS ID,row_number() over(order by  ccua.ccuser_id ,ccua.created )as row_name ,date(created +interval'5:30') as date 
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id 
where action  = 'Li' and  date(created +interval'5:30') >='2016-09-01' order by  ccua.ccuser_id ,ccua.created )a
full outer  join (SELECT ccua.created+interval'5:30' as yo_time ,row_number() over(order by  ccua.ccuser_id ,ccua.created )- 1 as row_name1 ,date(created +interval'5:30') as date
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id  
where action  in ('Lo','Off') and  date(created +interval'5:30') >='2016-09-01' order by  ccua.ccuser_id ,ccua.created )b
 on  a.row_name = b.row_name1 
order by yo



select username ,ccuser_id, date ,(case when max >  min and date(max) =  date(min) then max -min  
 when   date(min)= current_date and max is null then (now()+interval'5:30')- min else  null end )as login ,max,min  from ( 
SELECT ccuser_id,username ,date(created +interval'5:30') as date   ,max(case when action  in ('Lo','Off','Out') then ccua.created+interval'5:30' else null end ) , min(case when action  = 'Li' then ccua.created+interval'5:30' else null end )
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id  join auth_user au on ccc.auth_user_id  = au.id
where   date(created +interval'5:30') >='2016-09-10'  group by 1,2,3 order by  ccua.ccuser_id)a  where (case when max >  min and date(max) =  date(min) then max -min  
 when   date(min)= current_date and max is null then (now()+interval'5:30')- min else  null end) is not null order by date desc



  select * from 



