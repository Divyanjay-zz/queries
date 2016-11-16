--date	source	service	Leads created	pending 1 hr

SELECT date(a.created+interval'5:30') as LeadDate, 
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
WHEN a.service = 26 then 'Quikr'
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
when c24service = 'Ph' then 'Pharmacy'
else null end)service,
count(a.id), sum(case when lstat in (1,3,31) and (EXTRACT(EPOCH FROM (now() - next_contact)))>3600 then 1 else 0 end )
from "LeadManager_lead" as A 
LEFT OUTER JOIN "CampaignManager_campaign" as B ON (A.from_campaign_id = B.id) 
where date(a.created+interval'5:30')  between current_date-64 AND current_date group by 1,2,3 order by 1
