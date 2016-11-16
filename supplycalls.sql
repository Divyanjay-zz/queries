select ump.first_name||' '||coalesce(ump.last_name,'') ,au.first_name||' '||au.last_name, icdp.name,remarks ,imc.created+interval'5:30',imc.modified+interval'5:30',
(case when call_type = 1 then 'inbound' when call_type = 0 then  'outbound' else null end) ,phnum 
 from 
"UserManagement_c24provider" ump left join 
"InteractionManager_phonenumber" imp  on  ump.phone_id = imp.id left join 
"InteractionManager_callrecord" imc on ump.phone_id = imc.phnum_id  left join
"Company_callcenter" cc on imc.ccuser_id =  cc.id left join 
auth_user au on cc.auth_user_id =au.id left join 
"InteractionManager_calldisposition" icd   on imc.id = icd.callrecord_id left outer join 
"InteractionManager_calldispositiontype" icdp  on icd.call_disposition_type_id = icdp.id WHERE  date(imc.created+interval'5:30') >=current_date -10 
and username in
('vidyaj',
'rohanw',
'kishork',
'akashm',
'nitink',
'rajkumarm', 
'manishm',
'sandeept')
 order by 5 
