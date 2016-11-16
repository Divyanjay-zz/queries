select distinct umc.id, umc.first_name||' '||coalesce(umc.last_name,''),imp.phnum  from  
"RequestBooking_c24visit" rbc 
join "RequestBooking_booking" rbb on rbc.for_booking_id = rbb.id 
join "UserManagement_c24patient" ump on rbb.patient_id  = ump.id 
join "UserManagement_c24customer" umc on ump.customer_id = umc.id
join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id 
where date(date_time) between '2016-09-01' and current_date and curr_status in (1,2) and service in ('A','N','Ic')