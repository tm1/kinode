/* Server Version: WI-V6.3.2.4634 Firebird 1.5.  ODS Version: 10.1. */
SET NAMES WIN1251;

SET SQL DIALECT 3;

CONNECT 'LOCALHOST/3050:KAPPA' USER 'DEVEL001' PASSWORD 'primarykey';


SELECT 
  SESSION_KOD, 
  SESSION$DBUSER_KOD, 
  SESSION_STATE, 
  SESSION_LOCK, 
  SESSION_START,
  SESSION_LOCK
FROM TB_SESSION 
WHERE (SESSION_STATE = 0);

UPDATE TB_SESSION SES 
SET 
  SES.SESSION_FINISH = 'now',
  SES.SESSION_STATE = SES.SESSION_KOD,
  SES.SESSION_LOCK = 5
WHERE (SESSION_STATE = 0);

COMMIT WORK;


SELECT COUNT(*) 
FROM TB_SESSION 
WHERE (SESSION_STATE = 0);

SELECT 
  SESSION_KOD, 
  SESSION$DBUSER_KOD, 
  SESSION_STATE, 
  SESSION_LOCK, 
  SESSION_START,
  SESSION_LOCK
FROM TB_SESSION 
WHERE (SESSION_LOCK = 0);

COMMIT WORK;


SELECT COUNT(*) 
FROM TB_SESSION 
WHERE (SESSION_LOCK = 2);

SELECT COUNT(*) 
FROM TB_SESSION 
WHERE (SESSION_LOCK = 3);

SELECT COUNT(*) 
FROM TB_SESSION 
WHERE (SESSION_LOCK = 4);

SELECT COUNT(*) 
FROM TB_SESSION 
WHERE (SESSION_LOCK = 5);

COMMIT WORK;

