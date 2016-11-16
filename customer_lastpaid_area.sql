--Customer Name | Customer ID | Service | Start Date | Last Date of service | Last Paid Date | Booking Status|  Mode (Online or offline) | Current Outstanding Amount | Area (Google Vicinity)


select umc.first_name||coalesce(umc.last_name,''), umc.id, 
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
when service = 'Pc' then 'Pregnancy Care' else null end) as
service,date(start_date+interval'5:30'),date(max(rbc.date_time+interval'5:30')),date(max(ac.created)),
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
when bstat = 'LS' then 'LOST_SUPPLY' else null end) as booking_status,
 (case when payment_mode = '1' then 'NEFT-Bank Transfer'
when payment_mode = '2' then 'NetBanking'
when payment_mode = '3' then 'Credit Card'
when payment_mode = '4' then 'Debit Card'
when payment_mode = '5' then 'Cheque/Demand Draft'
when payment_mode = '6' then 'Cash'
when payment_mode = '7' then 'Citrus Payment'
when payment_mode = '8' then 'Online'
when payment_mode = '9' then 'Offline'
when payment_mode = '10' then 'InstaMojo' else null end) as payment_mode,
closing_balance, gl.name 
from "RequestBooking_c24visit" rbc
 join "RequestBooking_booking" rbb on rbc.for_booking_id = rbb.id 
 join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
 join "UserManagement_c24customer" umc on ump.customer_id = umc.id 
 join "Accounting_collections" ac on rbb.id = ac.booking_id
join (select * from (select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a
where rnk=1)b on umc.id = b.customer_id 
join "Geography_careaddress" gc on gc.id = rbb.address_id
join "Geography_locality" as gl on  ST_Contains(gl.poly, ST_SetSRID(ST_POINT(gl.longitude, gl.latitude),4326))
group by 1,2,3,4,7,8,9,10