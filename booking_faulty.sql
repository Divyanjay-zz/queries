--date	channel	service	allocations pending	faulty bookings

select 
date(RBB.CREATED+interval'5:30'),(CASE WHEN campaigntype_id = 1 then 'Facebook_Ad'
WHEN campaigntype_id = 2 then 'Google_Adwords'
WHEN campaigntype_id = 3 then 'Twitter'
WHEN campaigntype_id = 13 then 'Email'
WHEN campaigntype_id = 14 then 'SMS'
WHEN campaigntype_id = 15 then 'LinkedIn'
WHEN lead_type = 1 THEN 'JustDial'
WHEN lead_type = 2 THEN 'WebSite'
WHEN lead_type = 3 THEN 'Web-Promo'
WHEN lead_type = 4 THEN 'Web-Adwords'
WHEN lead_type = 5 THEN 'App'
WHEN lead_type = 6 THEN 'Quickr'
WHEN lead_type = 7 THEN 'Groupon'
WHEN lead_type = 8 THEN 'AskLaila'
WHEN lead_type = 9 THEN 'Sulekha'
WHEN lead_type = 20 THEN 'Manual'
WHEN lead_type = 21 THEN 'Hospital'
WHEN lead_type = 22 THEN 'MissedCall'
WHEN lead_type = 23 THEN 'Web-Unbounce'
WHEN lead_type = 24 THEN 'Practo'
WHEN lead_type = 24 THEN 'ColdCalling-PC'
WHEN a.service = 26 then 'Quikr'
ELSE 'Unknown' END) as LeadType,
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
else null end)service,
count(case when date(start_date+interval'5:30') <current_date and bstat = 'AR' then rbb.id else null end) as allocations_pending,
count(distinct(case when bstat not in ('Fin','X1','X2','LSK','LP','LS') and rbc.max < current_date-1   then rbb.id else null end)) as faulty_bookings 
from "RequestBooking_booking" rbb left join 
"LeadManager_lead" as A on rbb.for_lead_id = A.ID  join  "CampaignManager_campaign" as B ON (A.from_campaign_id = B.id) 
 left outer join  (select distinct id,for_booking_id,max(date_time) from "RequestBooking_c24visit"  where curr_status in (1,2,3) group by 1,2 )rbc on rbc.for_booking_id  = rbb.id
where date(a.created+interval'5:30')  between current_date-64 AND current_date AND lstat NOT IN (-2,-10,-4) AND a.service NOT IN (9) group by 1,2,3 order by 1 
