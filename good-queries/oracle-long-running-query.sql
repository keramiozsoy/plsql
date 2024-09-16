SELECT 
cast(SUBSTR(a.opname,1,10) as varchar2(10)) as "İşlem",
cast(SUBSTR(MESSAGE,1,40) as varchar2(40)) as "Mesaj",
cast(TO_CHAR(sysdate ,'HH24 MI SS') as varchar2(10)) as "Sistem Saati",
cast(TO_CHAR(a.start_time ,'HH24 MI SS') as varchar2(10)) as "Başlangıç Saati",
cast(TRUNC (time_remaining/60) as number(5,2)) as "Kalan Dk.",
cast(TO_CHAR(ROUND((a.sofar/a.totalwork)*100,2)) ||'%' as varchar2(10)) as "%",
cast(SUBSTR(b.username,1,20) as varchar2(20)) as "Kullanıcı",
cast(SUBSTR(b.osuser,1,10) as varchar2(20)) as "İşletim Sistemi Kullanıcıs",
cast(b.machine as varchar2(20)) as "Makina",
cast(b.status as varchar2(20)) as "Durum",
cast(SUBSTR(a.target,1,35) as varchar2(35)) as "Hedef",
cast('ALTER SYSTEM KILL SESSION '''||b.SID||','||b.SERIAL#||',@'||b.inst_id||''';' as varchar2(50)) KILL_SQL,
cast(a.sid as varchar2(35)) as sid,
cast(a.serial# as varchar2(35)) as serial
FROM gv$session_longops a, gv$session b
WHERE a.sid =b.sid
AND a.serial# =b.serial#
AND time_remaining > 0
ORDER BY a.start_time
