select rbb.id,
	umc.id,umc.first_name,umc.last_name,
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
	 else 'Unknown'
	 end),duration,duty_shift, rbb.start_date,rbb.estimated_visits,rbb.price_negotiated,date(rbb.created),
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
when bstat = 'LS' then 'LOST_SUPPLY' else '' end) as status


	 ,closing_balance
	from "RequestBooking_booking" rbb
	join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
	join  "UserManagement_c24customer" umc on ump.customer_id = umc.id
	left join 
	(SELECT  a.customer_id,date(modified+interval'5:30') as modified,closing_balance from "Billing_ledgerdetail" a
        join (select customer_id, max(modified) max from "Billing_ledgerdetail" group by customer_id) b
        on a.customer_id = b.customer_id and a.modified = b.max)a on umc.id  = a.customer_id 
        where (rbb.created at time zone 'Asia/Calcutta')::date between current_date-1 and current_date