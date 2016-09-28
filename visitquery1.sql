select (
CASE WHEN campaigntype_id = 1 then 'Facebook_Ad'
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
WHEN lead_type = 25 THEN 'ColdCalling-PC'
when lead_type = 26 then 'Quikr'
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
when rbb.service = 'Pc' then 'Pregnancy Care' ELSE null END)as service
,rbc.id , rbvs.curr_status as changed_status,date(tstamp+interval'5:30') as status_change_date,
date(rbc.date_time+interval'5:30') as scheduled_date,rbc.curr_status,price_negotiated,rbc.cg_fees+coalesce(rbc.cg_consumables,0)+coalesce(rbc.cg_travel,0) as cg_total,
rbb.id as booking_id,lml.id as lead_id
From  (select * from "RequestBooking_c24visitstatus"  where changes  like '%curr_status%' )rbvs 
right join "RequestBooking_c24visit" rbc on rbvs.visit_id = rbc.id
left join "RequestBooking_booking" rbb on rbc.for_booking_id =rbb.id
left join "LeadManager_lead"  lml on rbb.for_lead_id = lml.id left join "CampaignManager_campaign" cmc on lml.from_campaign_id = cmc.id 
where date(date_time+interval'5:30') between current_date-7 and  current_date+2 order by 6