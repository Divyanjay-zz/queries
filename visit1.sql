select (CASE when A.service = 'N' then 'Nurse Sister+Brother'
when A.service = 'A' then 'Attendant Aaya+Wardboy'
when A.service = 'P' then 'Physiotherapist'
when A.service = 'Nu' then 'Nutritionist'
when A.service = 'Eq' then 'Equipment'
when A.service = 'Ic' then 'InfantCare'
when A.service = 'St' then 'Speech Therapy'
when A.service = 'Ot' then 'Occupational Therapy'
when A.service = 'Cp' then 'Clinical Psychology'
when A.service = 'On' then 'Onco Nurse'
when A.service = 'Cc' then 'Cancer Coach'
when A.service = 'Pc' then 'Pregnancy Care'
when A.service = 'Pc' then 'Pregnancy Care' ELSE 'Unknown' END) as BookingService, (Case WHEN E.curr_status=1 THEN 'Scheduled' ELSE 'Completed-Tracked' END) as VisitStatus, E.date_time::date VisitDate, count(*), SUM(price_negotiated)
from "RequestBooking_c24visit" E, "RequestBooking_booking" A
WHERE E.curr_status IN (1,2,3) AND E.date_time::date >= cast(date_trunc('month', current_date) as date) AND E.date_time::date <= cast(current_date as date)
AND E.for_booking_id = A.id 
group by 1, 2,3
order by 3 DESC