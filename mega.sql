 


select umc.first_name||' '||umc.last_name,imp.phnum,
 string_agg(distinct(
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
ELSE 'Unknown' END)),',') as Channel,
string_agg(distinct(
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
when c24service = 'Cc' then 'Cancer Coach'  else 'unknown' end) ),',') as service,
count(distinct(c24service)), z.count, string_agg(distinct(split_part(all_google_addr_txt,':',2)),',')as location 
from  "RequestBooking_c24visit" rbc 
join "RequestBooking_booking"  rbb on rbc.for_booking_id = rbb.id  
left join "Geography_careaddress" gc on rbb.address_id =  gc.id 
join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
join "UserManagement_c24customer" umc on ump.customer_id = umc.id
join "LeadManager_lead" lml on rbb.for_lead_id = lml.id 
join "CampaignManager_campaign" cmc on  lml.from_campaign_id = cmc.id 
join "InteractionManager_callrecord" imc on umc.phnum_id  = imc.phnum_id 
join "InteractionManager_phonenumber" imp on umc.phnum_id  = imp.id 
LEFT join 
(select imq.phnum_id,count(imq.id) 
from "InteractionManager_callrecord" imq 
join (select phnum_id,min(id) as id from  "InteractionManager_callrecord" where status = 'completed' group by 1)b
on imq.phnum_id = b.phnum_id and imq.id < b.id  group by 1)z on umc.phnum_id  = z.phnum_id 

where date(lml.created+interval'5:30') >= '2016-02-01'
group by 1,2 ,6