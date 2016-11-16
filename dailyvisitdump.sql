select (rbc.id) as visit_id,

(case when curr_status = '0' then 'TESTING DO NOT USE'when curr_status = '1' then 'Scheduled'
when curr_status = '2' then 'Ongoing'
when curr_status = '3' then 'Completed'
when curr_status = '-1' then 'Cancelled Cust'
when curr_status = '-2' then 'Cancelled Prov'
when curr_status = '-3' then 'Cancelled C24'
when curr_status = '-4' then 'Bad Prov Not Reached'
when curr_status = '-5' then 'Bad LastMoment Cancellation Cust'
when curr_status = '-6' then 'Bad LastMoment Cancellation Prov'
when curr_status = '-7' then 'Half-Day'
when curr_status = '-8' then 'Booking Cancelled'
when curr_status = '-9' then 'Bad Cust Cancelled MISSEDCALL'
when curr_status = '-10' then 'Bad Prov Cancelled IVR'
when curr_status = '4' then 'Paid Leave' else 'unknown' end ) as status,
umc.id,umc.first_name,
umc.last_name,umcp.id,umcp.first_name,umcp.last_name,
(case when service='P' then 'Physio'
 when service='A' then 'Attendant'
 when service='N' then 'Nursing'
 when service='Ic' then 'InfantCare'
 when service='On' then 'Onco-Nurse'
 when service='Cc' then 'CancerCoach'
 when service='Nu' then 'Nutritionist'
 when service='Eq' then 'Equipment'
 when service='St' then 'SpeechTherapy'
 when service='Ot' then 'OccupationalTherapy'
 when service='Pc' then 'PregnancyCare'
 else 'Unknown'
 end) ,(date_time at time zone 'Asia/Calcutta')::date as visit_date, charge_fee,
charge_equip_rent,
charge_travel_a,
charge_consumable_a,
charge_other_a,
pay_fee,
pay_travel_a,
pay_consumable_a,
pay_other_a,
penalty,
incentive,
discount,rbc.duration,duty_shift,closing_balance
  
from "RequestBooking_booking" rbb
join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
join  "UserManagement_c24customer" umc on ump.customer_id = umc.id
join  "RequestBooking_c24visit" rbc on rbb.id = rbc.for_booking_id  
join  "Accounting_visitcpavalues" acv on rbc.id = acv.visit_id  
join "UserManagement_c24provider" umcp on rbc.cg_id =  umcp.id
left join (SELECT  a.customer_id,date(modified+interval'5:30') as modified,closing_balance from "Billing_ledgerdetail" a
        join (select customer_id, max(modified) max from "Billing_ledgerdetail" group by customer_id) b
        on a.customer_id = b.customer_id and a.modified = b.max)a on umc.id  = a.customer_id 

where(date_time at time zone 'Asia/Calcutta')::date between current_date-3 and current_date
order by visit_date