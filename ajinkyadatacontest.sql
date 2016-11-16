
select 
umc.id, rbb.id, date(rbb.created+interval'5:30'),umc.first_name||' '||coalesce(umc.last_name,''), imp.phnum,regexp_replace(raw_address,E'[;,:\\n\\r\\u2028]+','','g'),regexp_replace(remarks,E'[;,\\n\\r\\u2028]+','','g'),date(rbb.start_date+interval'5:30'),start_hour,
au.first_name||' '||coalesce(au.last_name,''),(CASE WHEN rbb.id = A.min then 'first_customer' else 'old_customer' end),price_negotiated,estimated_visits,no_of_caregivers,duration, 
(case when rbb.service = 'N' then 'Nurse Sister+Brother'
when rbb.service = 'A' then 'Attendant Aaya+Wardboy'
when rbb.service = 'P' then 'Physiotherapist'
when rbb.service = 'Nu' then 'Nutritionist'
when rbb.service = 'Eq' then 'Equipment'
when rbb.service = 'Ic' then 'InfantCare'
when rbb.service = 'St' then 'Speech Therapy'
when rbb.service = 'Ot' then 'Occupational Therapy'
when rbb.service = 'Cp' then 'Clinical Psychology'
when rbb.service = 'On' then 'Onco Nurse'
when rbb.service = 'Cc' then 'Cancer Coach'
when rbb.service = 'Pc' then 'Pregnancy Care'
when rbb.service = 'Ph' then 'Pharmacy'
when rbb.service = 'Cm' then 'Consumables'
when rbb.service = 'D' then 'Diagnostics'
when rbb.service = 'Py' then 'Physician' else null end) as service,
(case when closing_balance >0 then 'Not Paid' else 'Paid' end) as type,

(case when  bstat = 'CA' then 'Created App'
when  bstat = 'PCC' then 'Price Communicated to Cust App'
when bstat = 'AR' then 'Allocation Requested'
when  bstat = 'RR' then 'Replacement Requested'
when bstat = 'PAR' then 'PARTLY_ALLOC_REVIEW_LATER'
when  bstat = 'Fin' then 'Completed / Finished'
when  bstat = 'FA' then 'All Visits Allocated'
when bstat = 'X1' then 'Cancelled By Cust'
when bstat = 'X2' then 'Cancelled By Care24'
when  bstat = 'LSK' then 'LOST_SKILL'
when bstat  = 'LP' then 'LOST_PRICE'
when  bstat = 'LS' then 'LOST_SUPPLY'
when  bstat = 'PH' then 'Patient in Hospital'

else null end)
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
 left join (select * from (select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a where rnk=1)lb --ledger balance
 on umc.id = lb.customer_id       
where date(rbb.created+interval'5:30') >=
 '2016-11-07' order by date(rbb.created+interval'5:30')  


