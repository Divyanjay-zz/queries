
 select  gl.name as GeoLocation ,
(CASE WHEN service_offered = 'N' then 'Nurse Sister+Brother'
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
when service_offered = 'Ph' then 'Pharmacy'
when service_offered = 'Py' then 'Physician'
ELSE NULL END) as Booking_Service,gender,
(case when c24_employment_type = 'I' then 'Industrial'
when c24_employment_type = 'B' then 'Buffer'
when c24_employment_type = 'C' then 'Contract'
when c24_employment_type = 'D' then 'Dummy employee for testing'
when c24_employment_type = 'P' then 'Premium' else null end) as cg_type,
(case when shift_preference = 'D' then 'Day'
when shift_preference = 'N' then 'Night'
when shift_preference = '24' then 'Only 24 hour'
when shift_preference = 'DN' then 'Either' else null end) ,
count(distinct(case when cg_status = 1 then cg_id else null end )) 
,count(distinct(case when date(date_time+interval'5:30') = current_date then cg_id else null end ))as on_duty_today,
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+1 then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+2 then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+3 then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+4 then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+5 then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+6 then cg_id else null end )),
count(distinct(case when cg_status = 1 then cg_id else null end )) -count(distinct(case when date(date_time+interval'5:30') = current_date+7 then cg_id else null end ))
FROM  "UserManagement_c24provider" ump 
join "Geography_careaddress" gc  on gc.id = ump.address_id
 join "Geography_locality" gl  on  ST_Contains(gl.poly, ST_SetSRID(ST_POINT(gc.longitude, gc.latitude),4326)) 
left join  "RequestBooking_c24visit" rbc on rbc.cg_id = ump.id 
left join "ProviderProps_personalattributes" ppa on ump.id = ppa.for_cg_id 
group by 1,2,3,4,5  
