SELECT umc.id ,umc.first_name||' '||coalesce(umc.last_name,''),phnum,umc.email,
(case when payment_mode = '1' then 'Online'
when payment_mode = '2' then 'Offline' else null end),date(collection_date+interval'5:30'),to_char(collection_date+interval'5:30','HH24:mi:ss'),
(case when collection_agent = '1' then 'Rahul'
when collection_agent = '2' then 'Rajesh'
when collection_agent = '3' then 'Ajay'
when collection_agent = '4' then 'Vishal Yelkar'
when collection_agent = '5' then 'Vishal Yadav'
when collection_agent = '6' then 'Dijen Shah'
when collection_agent = '7' then 'Anil'
when collection_agent = '8' then 'Prakash'
when collection_agent = '9' then 'JD_Himalay'
when collection_agent = '10' then 'JD_Jayesh'
when collection_agent = '11' then 'JD_Amol'
when collection_agent = '12' then 'JD_Kishor' else null end) as collection_agent,au.first_name||' '||coalesce(au.last_name,''),closing_balance,coalesce(sum,0)+closing_balance
FROM "UserManagement_collectiontracking" umct right join "UserManagement_c24customer" umc on umct.customer_id = umc.id 
 left join "InteractionManager_phonenumber" imc on umc.phnum_id = imc.id 
 left join auth_user au on umct.updated_by_id = au.id left join
(select umc.id,sum(charge_fee)  from "Accounting_visitcpavalues" acv join "RequestBooking_c24visit" rbc on acv.visit_id = rbc.id join "RequestBooking_booking" rbb  on rbc.for_booking_id = rbb.id join "UserManagement_c24patient" ump on rbb.patient_id = ump.id
join "UserManagement_c24customer" umc on ump.customer_id = umc.id
 where customer_invoice_id is null and rbc.curr_status in (-7,3) and date(rbc.date_time+interval'5:30')>= '2016-04-01' group by 1)b 
 on umc.id  = b.id left join
(select customer_id,closing_balance from(
select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a
where rnk=1)a
 on umc.id  = a.customer_id where closing_balance is not null