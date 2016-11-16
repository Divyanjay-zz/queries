--cg provider


select ump.id, ump.first_name ,
ump.last_name,
(case when cg_status = '1' then 'Active'
when cg_status = '0' then 'In-Active'
when cg_status = '2' then 'Blacklisted'
when cg_status = '3' then 'Screening'
when cg_status = '4' then 'No-Contact'
else 'unknown' end) as cg_status, 
idfy.status,
(CASE when service_offered = 'N' then 'Nurse Sister+Brother'
when service_offered = 'A' then 'Attendant Aaya+Wardboy'
when service_offered = 'P' then 'Physiotherapist'
when service_offered = 'Nu' then 'Nutritionist'
when service_offered = 'Eq' then 'Equipment'
when service_offered = 'Ic' then 'InfantCare'
when service_offered = 'St' then 'Speech Therapy'
when service_offered = 'Ot' then 'Occupational Therapy'
when service_offered = 'Cp' then 'Clinical Psychology'
when service_offered = 'On' then 'Onco Nurse'
when service_offered = 'Cc' then 'Cancer Coach'
when service_offered = 'Pc' then 'Pregnancy Care'
when service_offered = 'Ph' then 'Pharmacy' ELSE NULL END) AS SERVICE_OFFERED,
imc.phnum as phone,
imp.phnum alt_phone,
 gender,
gl.name as locality,
(case when c24_employment_type = 'I' then 'Industrial'
when c24_employment_type = 'B' then 'Buffer'
when c24_employment_type = 'C' then 'Contract'
when c24_employment_type = 'D' then 'Dummy employee for testing'
when c24_employment_type = 'P' then 'Premium' else null end) as employment_status,
 date(ump.created +interval'5:30') as doj,
 first_visit_date,
 service_status,
 (case when cg_status = '1' then 'Active'
when cg_status = '0' then 'In-Active'
when cg_status = '2' then 'Blacklisted'
when cg_status = '3' then 'Screening'
when cg_status = '4' then 'No-Contact'
else 'unknown' end) as cg_status,
(case when shift_preference = 'D' then 'Day'
 when shift_preference = 'N' then 'Night'
 when shift_preference = 'DN' then 'Either'
 when shift_preference = '24' then 'Only 24 hour' ELSE NULL END) AS shift_preference,
(case when education = '1' then 'Uneducated'
when education = '5' then 'Something under 5th'
when education = '6' then '5th - 7th'
when education = '8' then '8th Pass'
when education = '10' then '10th Pass'
when education = '12' then '12th Pass'
when education = '13' then 'AnM'
when education = '21' then 'BSC Nursing'
when education = '14' then 'GnM'
when education = '15' then 'Other UG/PG/Diploma Non-PT'
when education = '16' then 'Diploma PT'
when education = '17' then 'BPT'
when education = '18' then 'MPT'
when education = '19' then 'PHD PT' else ''  end) as education,
workex




from "UserManagement_c24provider" ump
LEFT join "InteractionManager_phonenumber" imc on ump.phone_id = imc.id  
LEFT join "InteractionManager_phonenumber" imp on ump.alt_phone_id = imp.id  
left join "ProviderProps_cv" ppc on ump.id =  ppc.for_cg_id    
left join "ProviderProps_personalattributes" pppa on ump.id  = pppa.for_cg_id  
left join
	(select cg_id, (case when  max(date(date_time+interval'5:30')) >= current_date then 'live' else 'not allocated' end ) as service_status ,
	date(min(case when curr_status in (3,-7) then date_time else null end )) as first_visit_date 
	from "RequestBooking_c24visit"  where curr_status in (1,2,3,-7)   group by 1)visit
	on ump.id = visit.cg_id 
left join "TrainingAndOnboarding_idfyrecord" idfy on ump.id = idfy.provider_id
left join "Geography_careaddress" gc  on gc.id = ump.id
left join "Geography_locality" gl  on  ST_Contains(gl.poly, ST_SetSRID(ST_POINT(gc.longitude, gc.latitude),4326))
















select distinct umc.id ,umc.first_name||' '||coalesce(last_name,''),phnum,regexp_replace(raw_address,E'[,;\\n\\r\\u2028]+','','g'),(case when service = 'N' then 'Nurse Sister+Brother'
when service = 'A' then 'Attendant Aaya+Wardboy'
when service = 'P' then 'Physiotherapist'
when service = 'Nu' then 'Nutritionist'
when service = 'Eq' then 'Equipment'
when service = 'Ic' then 'InfantCare'
when service = 'St' then 'Speech Therapy'
when service = 'Ot' then 'Occupational Therapy'
when service = 'Cp' then 'Clinical Psychology'
when service = 'On' then 'Onco Nurse'
when service = 'Cc' then 'Cancer Coach'
when service = 'Pc' then 'Pregnancy Care' 
when service = 'Ph' then 'Pharmacy' else null end)as service ,date(start_date),rbb.id
from "RequestBooking_c24visit" rbc 

 left join "RequestBooking_booking" rbb on rbc.for_booking_id  = rbb.id  
 left join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
 left join "UserManagement_c24customer" umc on ump.customer_id = umc.id 
left join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id 
where curr_status in (1,2,3,-7)  
and date(date_time) >= current_date







select distinct umc.id ,
(umc.created+interval'5:30') as enrollment_date,


umc.first_name,
last_name,
imp.phnum,
impp.phnum,
umc.email,

regexp_replace(raw_address,E'[,;\\n\\r\\u2028]+','','g'),(case when service = 'N' then 'Nurse Sister+Brother'
when service = 'A' then 'Attendant Aaya+Wardboy'
when service = 'P' then 'Physiotherapist'
when service = 'Nu' then 'Nutritionist'
when service = 'Eq' then 'Equipment'
when service = 'Ic' then 'InfantCare'
when service = 'St' then 'Speech Therapy'
when service = 'Ot' then 'Occupational Therapy'
when service = 'Cp' then 'Clinical Psychology'
when service = 'On' then 'Onco Nurse'
when service = 'Cc' then 'Cancer Coach'
when service = 'Pc' then 'Pregnancy Care' 
when service = 'Ph' then 'Pharmacy' else null end)as service ,date(start_date),rbb.id
from "RequestBooking_c24visit" rbc 

 left join "RequestBooking_booking" rbb on rbc.for_booking_id  = rbb.id  
 left join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
 left join "UserManagement_c24customer" umc on ump.customer_id = umc.id 
left join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id 
left join "InteractionManager_phonenumber" impp on umc.alt_phnum_id = impp.id 
where curr_status in (1,2,3,-7)  
and date(date_time) >= current_date 








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



select c_id, gl.name from
(select ump.customer_id as c_id , max(rbb.address_id) max from
	 
	  "UserManagement_c24patient" ump 
	join "RequestBooking_booking" rbb  on rbb.patient_id  = ump.id group by 1 )b
join "Geography_careaddress" gc  on gc.id = b.max
 join "Geography_locality" gl  on  ST_Contains(gl.poly, ST_SetSRID(ST_POINT(gc.longitude, gc.latitude),4326))



 select customer_id,patient_id as c_id , max(address_id) max  from "RequestBooking_booking" group by 1 








