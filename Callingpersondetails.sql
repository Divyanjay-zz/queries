select au.username,umc.id,umc.first_name||' '||coalesce(umc.last_name,''),imp.phnum,date(imc.created+interval'5:30'),to_char(imc.created+interval'5:30','HH24:mi:ss'),(case when call_type = 1 then 'inbound' else 'oubound' end),status,imcdp.name,duration,remarks  from 
"InteractionManager_callrecord" imc 
left join "Company_callcenter" cc on imc.ccuser_id = cc.id
left  join "UserManagement_c24customer" umc on imc.phnum_id = umc.phnum_id
 join "InteractionManager_phonenumber" imp on imc.phnum_id = imp.id  
left join "InteractionManager_calldisposition" imcd on imc.id =imcd.callrecord_id 
left join  "InteractionManager_calldispositiontype" imcdp on imcd.call_disposition_type_id = imcdp.id 
left join auth_user au on cc.auth_user_id = au.id
where date(imc.created+interval'5:30') >= current_date-2 and cc.auth_user_id in('43','1046','1389','1440')