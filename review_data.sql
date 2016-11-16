--Booking Id 		Booking Status	Review Date 
select (case when bstat = 'CA' then 'Created App'
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
when bstat = 'PH' then 'LOST_SUPPLY' else null end), rbb.id ,date( max(date_time+interval'5:30')),next_review
from "RequestBooking_booking" rbb join "RequestBooking_c24visit" rbc on rbb.id  = rbc.for_booking_id  
where rbb.id in  (select distinct for_booking_id from  "RequestBooking_c24visit" where date(date_time) between current_date and current_date +1 AND curr_status in (1,2,3))
 group by 1,2,4
