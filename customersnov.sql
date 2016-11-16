select distinct
umc.id,
umc.first_name,
umc.last_name,
phnum, 
ac.sum,
bad_bdebts,
Discount,
(coalesce(lb.closing_balance,0))ledger_balance ,
(coalesce(ob.sum,0)+coalesce(lb.closing_balance,0))outstanding_balance,
(case when count_booking =1 then  service else 'Multiple' end) as service,
(case when count_booking =1 then  duration else null end) as duration,
(case when count_booking =1 then  start_date else null end) as start_date
from "RequestBooking_booking" rbb 
 right join "UserManagement_c24patient" ump on rbb. patient_id = ump.id 
 right join "UserManagement_c24customer" umc on ump.customer_id = umc.id
join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id
left join (select customer_id,sum(amount),
	   sum (case when type = '7' then amount else null end) as bad_bdebts,
	   sum (case when type = '6' then amount else null end) as Discount 
	   From "Accounting_collections" group by 1)ac on umc.id = ac.customer_id 
left join 
	 (select * from (select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a where rnk=1)lb --ledger balance
	  on umc.id = lb.customer_id 
left join
	(select umc.id,sum(charge_fee)  from "Accounting_visitcpavalues" acv join "RequestBooking_c24visit" rbc on acv.visit_id = rbc.id join "RequestBooking_booking" rbb  on 
	rbc.for_booking_id = rbb.id join "UserManagement_c24patient" ump on 
	rbb.patient_id = ump.id
	join "UserManagement_c24customer" umc on ump.customer_id = umc.id
	where customer_invoice_id is null and rbc.curr_status in (-7,3) and date(rbc.date_time+interval'5:30')>= '2016-04-01' group by 1)ob --outstanding Balance	     
	on umc.id  = ob.id  
left join 
	(select customer_id, count(rbb.id) as count_booking from "RequestBooking_booking" rbb 
	 right join "UserManagement_c24patient" ump on rbb. patient_id = ump.id group by 1) g 
	 on umc.id = g.customer_id
	where umc.created >= '2016-11-01' and service is not null 
	order by 1