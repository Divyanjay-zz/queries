select 
d.id as customer_id,
d.first_name as customer_first_name,
d.last_name as customer_last_name,
g.phnum as customer_no,
regexp_replace(e.name,E'[;,\\n\\r\\u2028]+','','g') as patient_name,
c.service,
f.first_name as cg_first_name,
f.last_name as cg_last_name,
h.phnum as cg_phone,
(b.date_time at time zone 'Asia/Calcutta')::date as visit_date,
a.charge_fee,
a.charge_travel_a,
discount,
a.charge_fee + a.charge_travel_a -discount as Total_Customer,
a.pay_fee,
a.pay_travel_a,
a.penalty,
a.pay_fee +a.pay_travel_a -a.penalty as cg_payout,
c.price_negotiated
from "Accounting_visitcpavalues" a, 
"RequestBooking_c24visit" b, 
"RequestBooking_booking" c, 
"UserManagement_c24customer" d, 
"UserManagement_c24patient" e, 
"UserManagement_c24provider" f,
"InteractionManager_phonenumber" g,
"InteractionManager_phonenumber" h
where a.visit_id=b.id
and b.curr_status =3
and (b.date_time at time zone 'Asia/Calcutta')::date between current_date-10 and current_date and b.for_booking_id=c.id
and c.patient_id=e.id
and e.customer_id=d.id
and b.cg_id=f.id
and d.phnum_id=g.id
and f.phone_id =  h.id