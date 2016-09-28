select dates,ccuser_ids,username,phone_call_attempts,phone_call_connects,inbound,outbound,talktime,unique_attempts,total_bookings,Attendant,Physio,Nurse,Infant_Care,Equipment,Nutritionist
,tt,aht,Pause_3_mins,Personal_break,Meeting,Training,Quality_feedback,Available,
new_login_time as login ,to_char(END_TIME,'YYYY-MM-DD HH24:MI:SS')AS END_TIME 
from((select E.date as dates,E.ccuser_id as ccuser_ids,phone_call_attempts,phone_call_connects,talktime,inbound,outbound, E.UserName, E.unique_attempts,total_bookings,Attendant,Physio,Nurse,Infant_Care,Equipment,Nutritionist,P.tt,P.AHT,E.min as start_time        ,new_login_time
FROM (select date(lmlq.created+interval'5:30')as date, lmlq.ccuser_id, au.id, (first_name || ' ' || last_name) as UserName, count(lmlq.lead_id) as LeadsTouched,
count(DISTINCT lmlq.lead_id) as unique_attempts ,MIN(lmlq.CREATED+interval'5:30')  from "LeadManager_leadqueuehistory" lmlq 
join "Company_callcenter" as ccc on lmlq.ccuser_id = ccc.id  join  auth_user au on ccc.auth_user_id = au.id
where date(created+interval'5:30') >='2016-08-01'  group by 1,2,3,4 ) as E 
left join (select  date(imc.created + interval'5:30')as dates,ccuser_id as ccuser_ids ,
count(call_type)as phone_call_attempts,count(case when status = 'completed' then 1 else null end) as phone_call_connects,
TO_CHAR((sum(duration) || ' second')::interval, 'HH24:MI:SS') as talktime ,sum (case when call_type = 1 then 1 else null end) as inbound,sum (case when call_type = 0 then 1 else null end) as outbound,to_char(min(imc.created+interval'5:30'),'yyyy-MM-DD HH24:MI:SS')		as new_login_time  from 
"InteractionManager_callrecord" imc join "Company_callcenter" as ccc on imc.ccuser_id = ccc.id 
where  date(imc.created + interval'5:30')>='2016-08-01' 
group by 1,2  order by 2,3 desc )k ON E.ccuser_id = k.ccuser_ids and k.dates = E.date 
left outer join (select date(created+interval'5:30'),rbb.created_by_id, count(rbb.id) as total_bookings,
count(distinct((case when service = 'A' then rbb.for_lead_id else null end  ))) as Attendant,
count(distinct((case when service = 'P' then rbb.for_lead_id else null end  ))) as Physio, 
count(distinct((case when service = 'N' then rbb.for_lead_id else null end  ))) as Nurse,
count(distinct((case when service = 'Ic' then rbb.for_lead_id else null end  ))) as Infant_Care,
count(distinct((case when service = 'Eq' then rbb.for_lead_id else null end  ))) as Equipment,
count(distinct((case when service = 'Nu' then rbb.for_lead_id else null end  ))) as Nutritionist
from "RequestBooking_booking" rbb join  "auth_user" au on rbb.created_by_id = au.id
where date(created+interval'5:30') >= '2016-08-01' 
group by 1,2)F 
ON E.id = F.created_by_id and F.date = E.date 
LEFT OUTER join
(select date(A.created) ,A.ccuser_id as user,to_char((avg(extract(epoch from ((B.created)-A.created)))||' SECOND')::INTERVAL,'HH24:MI:SS')AS aht,
to_char((sum(extract(epoch from ((B.created)-A.created)))||' SECOND')::INTERVAL,'HH24:MI:SS')AS tt 
from
(select * from "LeadManager_leadqueuehistory" where date(created) >='2016-08-01' and lead_queue_status =1 )A
join 
(select min(id),lead_id,ccuser_id,date(created)as date,min(created) as created from "LeadManager_leadqueuehistory" where date(created) >='2016-08-01' and lead_queue_status =0 group by 2,3,4)B 
on A.lead_id = B.lead_id and A.ccuser_id =B.ccuser_id  and B.min > A.id   and date(b.created)=date(a.created)
group by 1,2 order by 1)P on P.user = E.ccuser_id and E.date = P.date)q
left OUTER join
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
where  date(created +interval'5:30') >='2016-08-01' order by  ccua.ccuser_id ,ccua.created )a
join (SELECT ccua.created+interval'5:30' as yo_time ,row_number() over(order by  ccua.ccuser_id ,ccua.created )- 1 as row_name1 ,date(created +interval'5:30') as date
from "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id  
where  date(created +interval'5:30') >='2016-08-01' order by  ccua.ccuser_id ,ccua.created )b on 
a.row_name = b.row_name1 and a.date = b.date 
where b.yo_time-a.yo_time >= '00:00:00')B 
where action in ('P3','PB','M','T','QF','In')
group by 1,2,action order by 1)a 
group by 1,2)y
on q.ccuser_ids =y.user_id and q.dates = y.date 
left join 
(select ccuser_id,date(created+interval'5:30'),max(created+interval'5:30') as end_time from 
 "Company_callcenteruseractionhistory" ccua join "Company_callcenter" ccc on ccua.ccuser_id = ccc.id 
 where  date(created +interval'5:30') >='2016-08-01'  
 group by 1,2 order by 1,2)z on q.ccuser_ids =z.ccuser_id and q.dates = z.date)x where new_login_time is not null and end_time is not null order by 1