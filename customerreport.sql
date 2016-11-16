--Customer_ID,    Service	Start Date	Booking Status	Last Visit Status	Last Completed Visit Dt	Last Booking Remarks	Last ticket_Dt	Last ticket_Category	Last Call Disposition	Last Visit Remarks	Onboarding Agent	Last Assigned Caregiver	Current Outstanding Money
select   umc.id as cutomer_id, 
(case when service = 'N' then 'Nurse Sister Brother'
when service = 'A' then 'Attendant Aaya Wardboy'
when service = 'P' then 'Physiotherapist'
when service = 'Nu' then 'Nutritionist'
when service = 'Eq' then 'Equipment'
when service = 'Ic' then 'InfantCare'
when service = 'St' then 'Speech Therapy'
when service = 'Ot' then 'Occupational Therapy'
when service = 'Cp' then 'Clinical Psychology'
when service = 'On' then 'Onco Nurse'
when service = 'Cc' then 'Cancer Coach'
when service = 'Pc' then 'Pregnancy Care' else null end )service,
date(start_date+interval'5:30') as start_date,
(case when bstat = 'CA' then 'Created App'
when bstat = 'PCC' then 'Price Communicated to Cust App'
when bstat = 'AR' then 'Allocation Requested'
when bstat = 'RR' then 'Replacement Requested'
when bstat = 'PAR' then 'PARTLY_ALLOC_REVIEW_LATER'
when bstat = 'Fin' then 'Completed / Finished'
when bstat = 'FA' then 'All Visits Allocated'
when bstat = 'X1' then 'Cancelled By Cust'
when bstat = 'X2' then 'Cancelled By Care24'
when bstat = 'LSK' then 'LOST_SKILL'
when bstat = 'LP' then 'LOST_PRICE'
when bstat = 'LS' then 'LOST_SUPPLY'
when bstat = 'PH' then 'Patient in hospital' else null end) as booking_status,
(case when l.curr_status = '0' then 'TESTING DO NOT USE'
when l.curr_status = '1' then 'Scheduled'
when l.curr_status = '2' then 'Ongoing'
when l.curr_status = '3' then 'Completed'
when l.curr_status = '-1' then 'Cancelled Cust'
when l.curr_status = '-2' then 'Cancelled Prov'
when l.curr_status = '-3' then 'Cancelled C24'
when l.curr_status = '-4' then 'Bad Prov Not Reached'
when l.curr_status = '-5' then 'Bad LastMoment Cancellation Cust'
when l.curr_status = '-6' then 'Bad LastMoment Cancellation Prov'
when l.curr_status = '-7' then 'Half-Day'
when l.curr_status = '-8' then 'Booking Cancelled'
when l.curr_status = '-9' then 'Bad Cust Cancelled MISSEDCALL'
when l.curr_status = '-10' then 'Bad Prov Cancelled IVR'
when l.curr_status = '4' then 'Paid Leave' else null end )as last_status,
date(max(case when rbc.curr_status =3 then date_time+interval'5:30' else null end)) as last_completed_visit_date,
regexp_replace (rbb.status_reason,E'[\\n\\r\\u2028]+','','g') as status_reason,
ticket_date,  
(case when category = '1' then 'CG-NoShow'
when category = '2' then 'C24-WrongInvoice'
when category = '3' then 'C24-InvoiceDelay'
when category = '4' then 'CG-NotTrained'
when category = '5' then 'CG-UnHygienic'
when category = '6' then 'CG-NotPunctual'
when category = '7' then 'C24-NoAllocation'
when category = '8' then 'C24-NewBooking'
when category = '9' then 'ReplacementRequest'
when category = '10' then 'CG-LeaveRequest'
when category = '11' then 'CX-Complaints'
when category = '12' then 'CG-TaskCompletion'
when category = '13' then 'CG-Behaviour'
when category = '14' then 'CG-AsksforPayment'
when category = '15' then 'CG-Crime'
when category = '16' then 'CX-Feedback'
when category = '17' then 'CX-Query'
when category = '18' then 'CX-NoCommunication'
when category = '19' then 'CG-PaymentRequest'
when category = '20' then 'CG-PaymentDelay'
when category = '21' then 'CG-WrongPayment'
when category = '22' then 'CG-RequestForWork'
when category = '23' then 'CG-NewApplication'
when category = '24' then 'CG-InformationRequest'
when category = '25' then 'CG-ContractTermination'
when category = '26' then 'OTHERS'
when category = '27' then 'CG-Complaints'
when category = '28' then 'CX-CancelRequest'
when category = '29' then 'CG-MissedCall'
when category = '30' then 'OnlinePaymentLink'
when category = '31' then 'PaymentPickup'
when category = '32' then 'RefundRequest'
when category = '33' then 'CX-CallBack'
when category = '34' then 'Physio-CancelReschedule'
when category = '35' then 'Physio-Complaints'
when category = '36' then 'ServiceCompletion'
when category = '37' then 'CG-NotMarkedEndOfDuty'
when category = '38' then 'CG-NoShow_Again'
when category = '39' then 'BookingCancelledReview'
when category = '40' then 'CrossSellingCase-Physio'
when category = '41' then 'OnlinePaymentPending'
when category = '42' then 'OfflinePaymentNotDone'
when category = '43' then 'CG-UnplannedLeave'
when category = '44' then 'PathologyTestRequest'
when category = '45' then 'EquipmentRequest'
when category = '46' then 'MedicineDeliveryRequest'
when category = '47' then 'MedicalAidsRequest'
when category = '48' then 'CollectionCalling' else null end )as category ,
c.name,
regexp_replace (l.remarks,E'[\\n\\r\\u2028]+','','g') as remarks,
au.first_name||' '||au.last_name ,
l.cg_name,
b.closing_balance,
coalesce(sum,0)+b.closing_balance
from "RequestBooking_c24visit" rbc
join "RequestBooking_booking" rbb on rbc.for_booking_id = rbb.id 
join "UserManagement_c24patient" ump on rbb.patient_id = ump.id 
join "UserManagement_c24customer" umc on ump.customer_id = umc.id 
left join "Accounting_collections" ac on umc.id = ac.customer_id
left join 
	(select * from (select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a where rnk=1)b --ledger balance
	 on umc.id = b.customer_id 
left join
	(select umc.id,sum(charge_fee)  from "Accounting_visitcpavalues" acv join "RequestBooking_c24visit" rbc on acv.visit_id = rbc.id join "RequestBooking_booking" rbb  on rbc.for_booking_id = rbb.id join "UserManagement_c24patient" ump on 
	rbb.patient_id = ump.id
	join "UserManagement_c24customer" umc on ump.customer_id = umc.id
	where customer_invoice_id is null and rbc.curr_status in (-7,3) and date(rbc.date_time+interval'5:30')>= '2016-04-01' group by 1)lb --outstanding Balance
	on umc.id  = lb.id 	 
left join 
        (select rb.for_booking_id ,visit_id, curr_status ,rb.remarks,ump.first_name||' '||ump.last_name as cg_name from "RequestBooking_c24visit" rb join "UserManagement_c24provider" ump 
	on rb.cg_id  = ump.id
	join (select for_booking_id,max(id)as visit_id  from "RequestBooking_c24visit" where date_time <=current_date-1 group by 1)a on rb.id = a.visit_id )l 
        on rbb.id = l.for_booking_id 
left join
	(select qts.booking_id ,qts.id,date(created +interval'5:30')as ticket_date, category from "QRCTicketing_serviceticket" qts join
	(select booking_id  ,max(id) from "QRCTicketing_serviceticket" group by 1 )a on qts.id  = a.max)q 
	on rbb.id  = q.booking_id 
left join	
	(select imc.phnum_id, icdp.name from 
	"InteractionManager_callrecord" imc join
	(select phnum_id, max(id) from "InteractionManager_callrecord" group by 1)a on imc.id = a.max join
	"InteractionManager_calldisposition" icd   on imc.id = icd.callrecord_id left  outer join 
	"InteractionManager_calldispositiontype" icdp  on icd.call_disposition_type_id = icdp.id  group by 1,2 )c-- last call disposition
	on umc.phnum_id  = c.phnum_id 
join auth_user au on rbb.created_by_id =au.id
group by 1,2,3,4,5,7,8,9,10,11,12,13,14,15




