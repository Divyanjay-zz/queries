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
