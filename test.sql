
select linked2customer_id,
lml.patient_condition,
(case when lml.service = '1' then 'Nursing'
when lml.service = '2' then 'Physio'
when lml.service = '3' then 'Attendant'
when lml.service = '4' then 'InfantCare'
when lml.service = '5' then 'Baby Sitter'
when lml.service = '6' then 'Dietitian'
when lml.service = '7' then 'Elderly Care'
when lml.service = '8' then 'XSell Equip'
when lml.service = '9' then 'XSell Doc'
when lml.service = '10' then 'Care Package'
when lml.service = '11' then 'Premium Care Package'
when lml.service = '12' then 'Nutrition'
when lml.service = '13' then 'Equipment'
when lml.service = '14' then 'Mothers Package'
when lml.service = '15' then 'New Mothers Package'
when lml.service = '-1' then 'UNKNOWN'
when lml.service = '16' then 'Neuro Rehab'
when lml.service = '17' then 'Speech Therapy'
when lml.service = '18' then 'Occupational Therapy'
when lml.service = '19' then 'Clinical Psychology'
when lml.service = '20' then 'Pregnancy Care'
when lml.service = '21' then 'Mother and Infant Care'
when lml.service = '22' then 'Cancer Care'
when lml.service = '23' then 'Onco Nurse'
when lml.service = '24' then 'Cancer Coach'
when lml.service = '25' then 'Pharmacy'
when lml.service = '26' then 'Diagnostics'
when lml.service = '27' then 'XSELL DOC1'
when lml.service = '28' then 'XSELL DOC2'
when lml.service = '29' then 'XSELL DOC3'
when lml.service = '30' then 'Supply'
when lml.service = '31' then 'Physician' else null end) as lead_service,
( case when c24service = 'N' then 'Nursing'
when c24service = 'A' then 'Attendant'
when c24service = 'P' then 'Physio'
when c24service = 'Nu' then 'Nutrition'
when c24service = 'Eq' then 'Equipment'
when c24service = 'Ic' then 'InfantCare'
when c24service = 'St' then 'Speech Therapy'
when c24service = 'Ot' then 'Occupational Therapy'
when c24service = 'Cp' then 'Clinical Psychology'
when c24service = 'On' then 'Onco Nurse'
when c24service = 'Cc' then 'Cancer Coach'
when c24service = 'Pc' then 'Pregnancy Care' else 'unknown'end ) 
 as c24service,
lml.id,
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
when rbb.service = 'Cm' then 'Consumables'
when rbb.service = 'D' then 'Diagnostics'
when rbb.service = 'Py' then 'Physician' else null end) as booking_service,
lead_quantifier,
(case when lstat = '0' then 'CLOSED WAITING_ASSIGNMENT'
when lstat = '1' then 'CALL_SCHEDULED'
when lstat = '2' then 'ASSIGNED_CG'
when lstat = '3' then 'CALL_LATER'
when lstat = '4' then 'NEED_MORE_INFO'
when lstat = '5' then 'ASSIGNED_USING_AM_PROCESS'
when lstat = '-1' then 'LOST'
when lstat = '-2' then 'DUPLICATE'
when lstat = '-3' then 'BAD_LEAD'
when lstat = '-4' then 'SUPPLY_CALL'
when lstat = '-5' then 'GENERAL_INQUIRY'
when lstat = '-10' then 'TO_BE_DELETED'
when lstat = '31' then 'CALL_LATER_CUSTOMER' else null end) as lstat,
phone,
regexp_replace(remarks,E'[;,\\n\\r\\u2028]+','','g'),
lml.created,
c24offered_price,
cust_name,

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
ELSE 'Unknown' END) as Lead_Channel,rbb.id
from "LeadManager_lead"  lml  
join "RequestBooking_booking" rbb on lml.id  = rbb.for_lead_id 
left JOIN "CampaignManager_campaign" as cmc ON lml.from_campaign_id = cmc.id 
where
 linked2customer_id in 
(select a.customer_id From
(select ump.customer_id ,rbb.created from 
"RequestBooking_booking" rbb join 
"UserManagement_c24patient" ump on rbb.patient_id = ump.id  
join
(select customer_id, min(rbb.id) from 
"RequestBooking_booking" rbb join 
"UserManagement_c24patient" ump on rbb.patient_id = ump.id 
group by 1)a 
on rbb.id  = a.min where rbb.service = 'Eq' and date(rbb.created+interval'5:30')>= '2016-10-01')a
join
(select ump.customer_id ,rbb.created from 
"RequestBooking_booking" rbb join 
"UserManagement_c24patient" ump on rbb.patient_id = ump.id  where  rbb.service != 'Eq')b
on a.customer_id = b.customer_id  group by 1,a.created  having min(b.created) >= (a.created +interval'12:00'))
and (lml.created+interval'5:30' ) between '2016-10-01' and '2016-10-31'






