select 
service,umc.id, rbb.id, date(rbb.created+interval'5:30'),umc.first_name||' '||coalesce(umc.last_name,''), imp.phnum,regexp_replace(raw_address,E'[;,\\n\\r\\u2028]+','','g') ,regexp_replace(remarks,E'[;,\\n\\r\\u2028]+','','g'),date(rbb.start_date+interval'5:30'),start_hour,'',
au.first_name||' '||coalesce(au.last_name,''),(CASE WHEN rbb.id = A.min then 'first_customer' else 'old_customer' end),price_negotiated
from "RequestBooking_booking" rbb  
left join "UserManagement_c24patient" ump on rbb.patient_id  = ump.id 
left join "UserManagement_c24customer" umc on ump.customer_id = umc.id
left join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id   
left join 
(select b.booking_id,b.remarks from  "RequestBooking_bookingstatus" b join 
(select booking_id,max(id) from "RequestBooking_bookingstatus" group by 1)a on b.id = a.max)rbs on rbb.id = rbs.booking_id
 left join  "auth_user" au on rbb.created_by_id = au.id
 left join (select umc.id,min(rbb.id) as MIN
        from "RequestBooking_booking" rbb 
        join "UserManagement_c24patient" ump  on rbb.patient_id = ump.id
        join "UserManagement_c24customer" umc  on ump.customer_id = umc.id 
        group by 1)a on umc.id = a.id 
where date(rbb.created+interval'5:30') >= '2016-10-24'
and service in  ('Ph','Cm','D','Eq') order by date(rbb.created+interval'5:30') 

