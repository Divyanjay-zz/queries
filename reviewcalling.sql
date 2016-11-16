select  umc.id, umc.first_name||' '||coalesce(umc.last_name,''),imp.phnum , rbb.id,
(case when service = 'N' then 'Nurse Sister+Brother'
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
when service = 'Ph' then 'Pharmacy'
when service = 'Cm' then 'Consumables'
when service = 'D' then 'Daigonostics'
when service = 'Py' then 'Physician' else null end),
date(rbb.created),
(case when bstat = 'CA' then 'Created App'
when bstat = 'PCC' then 'Price Communicated to Cust App'
when bstat = 'AR' then 'Allocation Requested'
when bstat = 'RR' then 'Replacement Requested'
when bstat = 'PAR' then 'PARTLY_ALLOC_REVIEW_LATER'
when bstat = 'Fin' then 'Completed / Finished'
when bstat = 'FA' then 'All Visits Allocated'
when bstat = 'X1' then 'Cancelled By Cust'
when bstat = 'X2' then 'Cancelled By Care24'
when bstat = 'LSK' then 'LOST_SKILL'
when bstat = 'LP' then 'LOST_PRICE'
when bstat = 'LS' then 'LOST_SUPPLY'
when bstat = 'PH' then 'Patient in Hospital' else null end ),
vtdate
from 
"RequestBooking_booking" rbb 
left join ( 
select for_booking_id,vtdate
from
 (
select for_booking_id,DATE(max(date_time+INTERVAL'5:30')) vtdate
from "RequestBooking_c24visit"
where curr_status in (1,2,3,-7)
group by 1
)a )rbc  on rbb.id = rbc.for_booking_id 
LEFT join "UserManagement_c24patient" ump on rbb.patient_id  = ump.id 
LEFT join "UserManagement_c24customer" umc on ump.customer_id = umc.id
LEFT join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id   
where  bstat in  ('AR','PAR','RR','PCC','FA') 
AND service IN ('A','N','Ic')
and date(rbb.created+interval'5:30')>='2016-04-01' 
and  vtdate <= current_date
order by 1