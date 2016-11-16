select distinct c.id,c.first_name,c.last_name,Y.outstanding_balance,X.closing_balance, (case when Y.outstanding_balance is null then 0 else Y.outstanding_balance end) + (case when X.closing_balance is null then 0 else X.closing_balance end)
from "RequestBooking_booking" a , "RequestBooking_c24visit" f,
"UserManagement_c24patient" e, "InteractionManager_phonenumber" d,"UserManagement_c24customer" c
left outer join
(
select customer_id,sum(case 
when d.curr_status=-7 then 0.5 * e.charge_fee
when d.curr_status=3 then e.charge_fee
end) outstanding_balance
from "RequestBooking_booking" a , "UserManagement_c24patient" b, "UserManagement_c24customer" p, "RequestBooking_c24visit" d, "Accounting_visitcpavalues" e
where a.patient_id=b.id
and b.customer_id=p.id
and a.id=d.for_booking_id
and d.id=e.visit_id
and d.curr_status in (3,-7)
and d.date_time::date >= '2016-04-01'
and e.customer_invoice_id is null
group by 1
) Y 
on c.id=Y.customer_id
left outer join
(
select customer_id,closing_balance from (
select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) b
where rnk=1
) X
on c.id=X.customer_id
where 
a.patient_id=e.id
and e.customer_id=c.id
and c.phnum_id=d.id
and a.start_date >= current_date-7 -- replace with T-7
and a.start_date <= current_date + 1  -- replace with current date + 1
and c.created::date >= current_date-7 
and a.service in ('A','N','P','Ic')
and f.curr_status in (3,-7,1,2)
and a.id=f.for_booking_id
and f.date_time::date >= current_date 
and  (case when Y.outstanding_balance is null then 0 else Y.outstanding_balance end) + (case when X.closing_balance is null then 0 else X.closing_balance end) >= 0  --- Replace with current date 