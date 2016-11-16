-- date	service	completed_visits	price_completed_visit	cancel_or_lost	faulty_visits	total scheduled visits

select date(date_time + interval'5:30'),(case 
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
else null end)service,count(distinct(case when rbc.curr_status in( 3,-7) then rbc.id else null end)) as completed_visits  , sum(case when rbc.curr_status in( 3,-7) then price_negotiated else null end) as price_completed_visits,
count(DISTINCT(case when rbc.curr_status not in( 1,2,3,-7) then rbc.id else null end)) as cancel_or_lost ,
count(DISTINCT(case when rbc.curr_status in( 1,2) and date(rbc.date_time+interval'5:30' )<current_date then rbc.id  else null end)) as faulty_visits,
count(rbc.id)as total
from  "RequestBooking_c24visit" rbc  join "RequestBooking_booking" rbb on rbc.for_booking_id = rbb.id where  date(date_time + interval'5:30') between current_date-64 AND current_date  group by 1,2
