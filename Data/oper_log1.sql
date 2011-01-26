select
  OPR.OPER_KOD, OPR.OPER_VER, OPR.OPER_STATE, OPR.OPER_SELECTED,
  OPR.OPER_ACTION,
  case OPR.OPER_ACTION
         when 'R' then 'Reserve'
         when 'P' then 'Sale'
         when 'A' then 'Actualize'
         when 'J' then 'Free'
         when 'F' then 'Restore'
         when 'S' then 'Select'
         when 'C' then 'Cancel'
         else 'Unknown' end,
  OPR.OPER_PREVIOUS, OPR.OPER_PRINT_COUNT,
  OPR.OPER_CHEQED, OPR.OPER_PLACE_ROW, OPR.OPER_PLACE_COL,
  OPR.OPER_COST_VALUE, OPR.OPER_LOCK_STAMP, OPR.OPER_SALE_STAMP,
  OPR.OPER_SALE_VER, OPR.OPER_SALE_FORM,
  case OPR.OPER_SALE_FORM
         when 0 then 'Unpaid'
         when 1 then 'Cash'
         when 2 then 'Credit'
         else 'Unknown' end,
  OPR.OPER_MOD_DATE,
  OPR.OPER_MOD_STAMP, OPR.OPER_REPERT_KOD, OPR.OPER_REPERT_VER,
  OPR.OPER_TICKET_KOD, OPR.OPER_TICKET_VER, OPR.OPER_SEAT_KOD,
  OPR.OPER_SEAT_VER, OPR.OPER_MISC_REASON, OPR.OPER_MISC_SERIAL,
  OPR.SESSION_ID, OPR.DBUSER_KOD, OPR.DBUSER_NAM, OPR.SESSION_HOST
from SP_TB_OPER_S(:IN_FILT_REPERT, :IN_OPER_KOD, :IN_VERSIONED) OPR
where
  ((OPR.OPER_PLACE_ROW = :VAR_OPER_ROW1) and (OPR.OPER_PLACE_COL = :VAR_OPER_COL1))
  or ((OPR.OPER_PLACE_ROW = :VAR_OPER_ROW2) and (OPR.OPER_PLACE_COL = :VAR_OPER_COL2))
order by
  OPR.OPER_KOD, OPR.OPER_VER

