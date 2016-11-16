SELECT umc.id ,umc.first_name||' '||coalesce(umc.last_name,''),umc.email,
closing_balance
from
"UserManagement_c24customer" umc left join
 (select customer_id,closing_balance from(
select customer_id,closing_balance,rank() over (partition by customer_id order by id desc ) rnk from "Billing_ledgerdetail" ) a
where rnk=1)a on umc.id  = a.customer_id where closing_balance is not null
