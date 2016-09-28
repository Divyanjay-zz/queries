(select created::date,(case 
when type=1 then 'Service-Fees'
when type=2 then 'Advance'
when type=4 then 'Others'
when type=5 then 'Security-Deposit'
end ),(
case 
when payment_mode=1 then 'NEFT-Bank Transfer'
when payment_mode=2 then 'NetBanking'
when payment_mode=3 then 'Credit Card'
when payment_mode=4 then 'Debit Card'
when payment_mode=5 then 'Cheque/Demand Draft'
when payment_mode=6 then 'Cash'
when payment_mode=7 then 'Citrus Payment'
when payment_mode=8 then 'Online'
when payment_mode=9 then 'Offline'
when payment_mode=10 then 'InstaMojo'
when payment_mode=11 then 'System'

end),sum(amount) from "Accounting_collections" 
where created::date > '2016-09-13'
group by 1,2,3
order by 1 )
union
(select created::date,(case 
when type=3 then 'Refund'
when type=4 then 'Others'
when type=6 then 'Discount'
when type=7 then 'Bad Debt'
when type=8 then 'Adjustment-Booking Rate'
when type=9 then 'Adjustment-Visit Track'
end),'',sum(amount) from "Accounting_payments"
where created::date > '2016-09-13'
group by 1,2
order by 1)