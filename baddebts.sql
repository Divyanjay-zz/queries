select customer_id ,umc.first_name, umc.last_name, imp.phnum ,case when type = '3' then amount else null end Refund,
case when type = '4' then amount else null end	Others,
case when type = '6' then amount else null end 	Discount,
case when type = '7' then amount else null end 	Bad_Debt,
case when type = '8' then amount else null end 	Adjustment_Booking_Rate,
case when type = '9' then amount else null end	Adjustment_Visit_Track,date(ap.created+interval'5:30'),username,regexp_replace(description,E'[,:;\\n\\r\\u2028]+','','g') from "Accounting_payments" ap
left join auth_user au on ap.created_by_id = au.id 
left join   "UserManagement_c24customer" umc on  umc.id = ap.customer_id 
 left join "InteractionManager_phonenumber" imp on umc.phnum_id = imp.id 
where date(ap.created)>= '2016-10-01' and customer_id is not null
order by ap.created 
