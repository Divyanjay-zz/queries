select umc.id as CG_ID , 
umc.first_name||' '||coalesce(umc.last_name,'') as name,
phnum,
bank_id,
gdb.name as bank_name,
ac_num,
branch,
ifsc,
ac_type,
verified,
au.first_name ||' '||coalesce(au.last_name,'')
from "UserManagement_c24provider" umc 
join "ProviderProps_cgaccount" ppa on umc.id  = ppa.for_cg_id 
join "InteractionManager_phonenumber" imc on umc.phone_id = imc.id   
join "GenericData_bank" gdb on ppa.bank_id = gdb.id   
join auth_user au on ppa.verified_by_id = au.id 