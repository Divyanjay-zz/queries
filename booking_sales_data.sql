select au.first_name||' '||coalesce(au.last_name,''),service ,	(CASE WHEN rbb.id = A.min then 'first_customer' else 'old_customer' end),date(rbb.created+interval'5:30'),rbb.created_by_id,rbb.id,customer_id ,price_negotiated ,estimated_visits
from "RequestBooking_booking" rbb 
join  "auth_user" au on rbb.created_by_id = au.id
join "UserManagement_c24patient" ump  on rbb.patient_id = ump.id
join "UserManagement_c24customer" umc  on ump.customer_id = umc.id 
join 
(select umc.id,min(rbb.id) as MIN
from "RequestBooking_booking" rbb 
join "UserManagement_c24patient" ump  on rbb.patient_id = ump.id
join "UserManagement_c24customer" umc  on ump.customer_id = umc.id 
group by 1)a on umc.id = a.id 
where date(rbb.created+interval'5:30') >= '2016-07-01' and service not in ('Eq')order by 1,5