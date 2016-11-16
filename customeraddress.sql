select b.c_id, gl.name as locailty, regexp_replace(raw_address,E'[;,\\r\\n\\u2028]+',' ','g') from 
(select c_id, max,raw_address from 
	"RequestBooking_booking" rbb  
	join "UserManagement_c24patient" ump on rbb.patient_id  = ump.id 
	join "UserManagement_c24customer" umc on ump.customer_id = umc.id
join 
	(select umc.id as c_id , max(rbb.address_id) max from
	"RequestBooking_booking" rbb  
	left  join "UserManagement_c24patient" ump on rbb.patient_id  = ump.id 
	left join "UserManagement_c24customer" umc on ump.customer_id = umc.id group by 1)a 
on rbb.address_id = a.max )b
left join "Geography_careaddress" gc  on gc.id = b.max
left join "Geography_locality" gl  on  ST_Contains(gl.poly, ST_SetSRID(ST_POINT(gc.longitude, gc.latitude),4326))