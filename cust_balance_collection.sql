--Service	CUSTOMER_ID	ledger balance	outstanding balance	collected ammount	MAX_COMPLETED_visit DATE

select (case 
when service = 'N' then 'Nurse Sister+Brother'
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
else null end)service,
 umc.id, (coalesce(lb.closing_balance,0))ledger_balance ,(coalesce(sum,0)+coalesce(lb.closing_balance,0))outstanding_balance,ac.amount,date(max(case when curr_status = 3 then date_time else  null end)) from 
"RequestBooking_c24visit" rbc  join 
"RequestBooking_booking" rbb   on rbc.for_booking_id = rbb.id 
left outer join "UserManagement_c24patient" ump on rbb.patient_id = ump.id
left outer join "UserManagement_c24customer" umc on ump.customer_id  = umc.id
 left outer join (select customer_id, sum(amount) as amount from "Accounting_collections" group by 1) ac on umc.id = ac.customer_id 
left outer join 
	(select * from (select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a where rnk=1)lb --ledger balance
	on umc.id = lb.customer_id 
left outer join
	(select umc.id,sum(charge_fee)  from "Accounting_visitcpavalues" acv join "RequestBooking_c24visit" rbc on acv.visit_id = rbc.id join "RequestBooking_booking" rbb  on 
	rbc.for_booking_id = rbb.id join "UserManagement_c24patient" ump on 
	rbb.patient_id = ump.id
	join "UserManagement_c24customer" umc on ump.customer_id = umc.id
	where customer_invoice_id is null and rbc.curr_status in (-7,3) and date(rbc.date_time+interval'5:30')>= '2016-04-01' group by 1)ob --outstanding Balance	     
	on umc.id  = ob.id 
group by 2,1,3,4,5 order by 1,2