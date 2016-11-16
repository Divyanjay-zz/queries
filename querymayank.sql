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
where date(a.created+interval'5:30')  between current_date-64 AND current_date AND lstat NOT IN (-2,-10,-4) AND a.service NOT IN (9) group by 1,2,3 order by 1





--date	source	service	Leads modified

select date(lms.tstamp+interval'5:30') as LeadDate, 
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


--date	channel	service	count_bookings	total visits created	total price_bookings	tat
select date(RBB.CREATED+interval'5:30'),(CASE WHEN campaigntype_id = 1 then 'Facebook_Ad'
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
else null end)service,COUNT(distinct(rbb.id)) count_bookings , sum(estimated_visits) as total_visits_created ,sum(price_negotiated * (estimated_visits*1.0)) ,
to_char(avg( (rbb.created - A.created)),'HH24:mi:ss') as tat2 from 
"RequestBooking_booking" rbb left outer join 
"LeadManager_lead" as A on rbb.for_lead_id = A.ID  left outer join  "CampaignManager_campaign" as B ON (A.from_campaign_id = B.id) 
 where date(a.created+interval'5:30')  between current_date-64 AND current_date AND lstat NOT IN (-2,-10,-4) AND a.service NOT IN (9) group by 1,2,3 order by 1 




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




















--date	service	no_show	noshow_replaced	noshow_not_replaced







select date(qts.created+interval'5:30'),(case
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
else null end)service,count(qts.id) as no_show ,count(case when status = 3 then qts.id else null end)as no_show_replaced,count(case when status != 3 then qts.id else null end)as no_show_replaced FROM "QRCTicketing_serviceticket" qts 
join "RequestBooking_booking" rbb on qts.booking_id = rbb.id 
where category in (1,38)  group by 1 ,2 order by 1




--Service	CUSTOMER_ID	ledger balance	outstanding balance	collected ammount	MAX_COMPLETED_visit DATE

select (case 
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
else null end)service,
 umc.id, (coalesce(lb.closing_balance,0))ledger_balance ,(coalesce(sum,0)+coalesce(lb.closing_balance,0))outstanding_balance,ac.amount,date(max(case when curr_status = 3 then date_time else  null end)) from 
"RequestBooking_c24visit" rbc  join 
"RequestBooking_booking" rbb   on rbc.for_booking_id = rbb.id 
left outer join "UserManagement_c24patient" ump on rbb.patient_id = ump.id
left outer join "UserManagement_c24customer" umc on ump.customer_id  = umc.id
 left outer join (select customer_id, sum(amount) as amount from "Accounting_collections" group by 1) ac on umc.id = ac.customer_id 
left outer join 
	(select * from (select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a where rnk=1)lb --ledger balance
	on umc.id = lb.customer_id 
left outer join
	(select umc.id,sum(charge_fee)  from "Accounting_visitcpavalues" acv join "RequestBooking_c24visit" rbc on acv.visit_id = rbc.id join "RequestBooking_booking" rbb  on 
	rbc.for_booking_id = rbb.id join "UserManagement_c24patient" ump on 
	rbb.patient_id = ump.id
	join "UserManagement_c24customer" umc on ump.customer_id = umc.id
	where customer_invoice_id is null and rbc.curr_status in (-7,3) and date(rbc.date_time+interval'5:30')>= '2016-04-01' group by 1)ob --outstanding Balance	     
	on umc.id  = ob.id 
group by 2,1,3,4,5 order by 1,2