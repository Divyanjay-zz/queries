SELECT date(a.created+interval'5:30') as LeadDate,
(CASE when a.service = '1' then 'Nursing'
when a.service = '2' then 'Physio'
when a.service = '3' then 'Attendant'
when a.service = '4' then 'InfantCare'
when a.service = '5' then 'Baby Sitter'
when a.service = '6' then 'Dietitian'
when a.service = '7' then 'Elderly Care'
when a.service = '8' then 'XSell Equip'
when a.service = '9' then 'XSell Doc'
when a.service = '10' then 'Care Package'
when a.service = '11' then 'Premium Care Package'
when a.service = '12' then 'Nutrition'
when a.service = '13' then 'Equipment'
when a.service = '14' then 'Mothers Package'
when a.service = '15' then 'New Mothers Package'
when a.service = '-1' then 'UNKNOWN'
when a.service = '16' then 'Neuro Rehab'
when a.service = '17' then 'Speech Therapy'
when a.service = '18' then 'Occupational Therapy'
when a.service = '19' then 'Clinical Psychology'
when a.service = '20' then 'Pregnancy Care'
when a.service = '21' then 'Mother and Infant Care'
when a.service = '22' then 'Cancer Care'
when a.service = '23' then 'Onco Nurse'
when a.service = '24' then 'Cancer Coach'
when a.service = '25' then 'Pharmacy'
when a.service = '26' then 'Diagnostics'
when a.service = '27' then 'XSELL DOC1'
when a.service = '28' then 'XSELL DOC2'
when a.service = '29' then 'XSELL DOC3'
when a.service = '30' then 'Supply'
when a.service = '31' then 'Physician'
ELSE 'Unknown' END) as Lead_service,
(CASE WHEN campaigntype_id = 1 then 'Facebook_Ad'
WHEN campaigntype_id = 2 then 'Google_Adwords'
WHEN campaigntype_id = 3 then 'Twitter'
WHEN campaigntype_id = 13 then 'Email'
WHEN campaigntype_id = 14 then 'SMS'
WHEN campaigntype_id = 15 then 'LinkedIn'
when lead_type = '1' then 'JustDial'
when lead_type = '2' then 'WebSite'
when lead_type = '3' then 'Web-Promo'
when lead_type = '4' then 'Web-Adwords'
when lead_type = '5' then 'App'
when lead_type = '6' then 'Quickr'
when lead_type = '7' then 'Groupon'
when lead_type = '8' then 'AskLaila'
when lead_type = '9' then 'Sulekha'
when lead_type = '20' then 'Manual'
when lead_type = '21' then 'Hospital'
when lead_type = '22' then 'MissedCall'
when lead_type = '23' then 'Web-Unbounce'
when lead_type = '24' then 'Practo'
when lead_type = '25' then 'ColdCalling-PC'
when lead_type = '26' then 'Quikr'
when lead_type = '27' then 'Cancer Referral'
when lead_type = '28' then 'OnGroundSale'
ELSE 'Unknown' END) as LeadType,
(CASE WHEN lead_type IN (2,3,4,5,20,21,22,23) or campaigntype_id IN (1,2,3,13,14,15)  THEN 'Earned' ELSE 'Bought' END) as LeadSource, a.id ,
(case when date(lmq.min+interval'5:30')>Date(A.created+interval'5:30') then
 EXTRACT(EPOCH FROM (lmq.min - A.created) - ((date(lmq.min+interval'5:30')-Date(A.created+interval'5:30')) * interval'9:00' ))
else EXTRACT(EPOCH FROM (lmq.min - A.created)) end ),
lstat,lmq.lead_id,
(case when lstat not in (0,1,5) and (EXTRACT(EPOCH FROM (now() - next_contact)))>3600 then 1 else 0 end ),
(case when  extract ('hour' from a.created+interval'5:30')  between 8 AND 23 then 'operational' else 'AOH' END )
 from "LeadManager_lead" as A
LEFT OUTER JOIN (select lead_id,min(created) from "LeadManager_leadqueuehistory" where date(created+interval'5:30') >= current_date-37 group by 1) lmq on a.id =lmq.lead_id
LEFT OUTER JOIN "CampaignManager_campaign" as B ON (A.from_campaign_id = B.id)
where date(a.created+interval'5:30')  between current_date-37 AND current_date AND lstat NOT IN (-2,-10,-4) AND a.service NOT IN (9) order by 1