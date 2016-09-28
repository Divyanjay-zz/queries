select customer_id, date(created +interval'5:30'),amount,
(case when type = '1' then 'Service Fees'
when type = '2' then 'Advance'
when type = '4' then 'Others' else null end )as type  ,(case when payment_mode = '1' then 'NEFT-Bank Transfer'
when payment_mode = '2' then 'NetBanking'
when payment_mode = '3' then 'Credit Card'
when payment_mode = '4' then 'Debit Card'
when payment_mode = '5' then 'Cheque/Demand Draft'
when payment_mode = '6' then 'Cash'
when payment_mode = '7' then 'Citrus Payment'
when payment_mode = '8' then 'Online'
when payment_mode = '9' then 'Offline'
when payment_mode = '10' then 'InstaMojo' else null end) from "Accounting_collections" where date(created+interval'5:30') >= current_date-3