select customer_id,umc.first_name,umc.last_name,phnum,umc.email, date(ac.created +interval'5:30'),payment_date,amount,
(case when type = '1' then 'Service Fees'
when type = '2' then 'Advance'
when type = '4' then 'Others' else null end )as type ,reference_no, cheque_no ,(case when payment_mode = '1' then 'NEFT-Bank Transfer'
when payment_mode = '2' then 'NetBanking'
when payment_mode = '3' then 'Credit Card'
when payment_mode = '4' then 'Debit Card'
when payment_mode = '5' then 'Cheque/Demand Draft'
when payment_mode = '6' then 'Cash'
when payment_mode = '7' then 'Citrus Payment'
when payment_mode = '8' then 'Online'
when payment_mode = '9' then 'Offline'
when payment_mode = '10' then 'InstaMojo' else null end),au.username from "Accounting_collections" ac 
join "UserManagement_c24customer" umc on ac.customer_id = umc.id 
join "InteractionManager_phonenumber" imp  on umc.phnum_id = imp.id 
left join auth_user au  on ac.created_by_id = au.id 
where date(ac.created+interval'5:30') >= current_date-2
