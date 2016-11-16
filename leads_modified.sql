﻿select date(lms.tstamp+interval'5:30') as LeadDate, 
(CASE WHEN campaigntype_id = 1 then 'Facebook_Ad'
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
WHEN lead_type = 26 then 'Quikr'
ELSE 'Unknown' END) as LeadType,
(case when c24service = 'N' then 'Nurse Sister+Brother'
when c24service = 'A' then 'Attendant Aaya+Wardboy'
when c24service = 'P' then 'Physiotherapist'
when c24service = 'Nu' then 'Nutritionist'
when c24service = 'Eq' then 'Equipment'
when c24service = 'Ic' then 'InfantCare'
when c24service = 'St' then 'Speech Therapy'
when c24service = 'Ot' then 'Occupational Therapy'
when c24service = 'Cp' then 'Clinical Psychology'
when c24service = 'On' then 'Onco Nurse'
when c24service = 'Cc' then 'Cancer Coach'
when c24service = 'Pc' then 'Pregnancy Care'
else null end)service,
count(distinct(for_lead_id)) from "LeadManager_leadstatus" lms  left  outer join "LeadManager_lead" lml on lms.for_lead_id= lml.id  
LEFT OUTER JOIN "CampaignManager_campaign" as B ON (lml.from_campaign_id = B.id) 
where date(lms.tstamp+interval'5:30')  between current_date-64 AND current_date AND lml.lstat NOT IN (-2,-10,-4) AND lms.lstat != 1 AND lml.service NOT IN (9) group by 1,2,3 order by 1 
