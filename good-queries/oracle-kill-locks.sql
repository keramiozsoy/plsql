SELECT DISTINCT 'alter system kill session '''
  || s.sid
  ||','
  ||s.serial#||',@'||s.inst_id
  ||''';' c,
  p.username username ,
  p.pid pid ,
  s.sid sid ,
  s.serial# serial ,
  p.spid spid ,
  s.username username1,
  s.status
FROM gv$process p ,
  gv$_lock l1,
  gv$lock l2,
  gv$resource r ,
  sys.obj$ o ,
  sys.user$ u ,
  gv$session s
WHERE s.paddr = p.addr
AND s.saddr   = l1.saddr
AND l1.raddr  = r.addr
AND l2.addr   = l1.laddr
AND l2.type  <> 'MR'
AND r.id1     = o.obj# (+)
AND o.owner#  = u.user# (+)
AND s.sid IN
  (SELECT
    /*+ ORDERED */
    blocker.sid
  FROM
    (SELECT * FROM gv$lock WHERE block != 0 AND type = 'TX'
    ) blocker ,
    gv$lock waiting
  WHERE waiting.type='TX'
  AND waiting.block = 0
  AND waiting.id1   = blocker.id1
  ) 
