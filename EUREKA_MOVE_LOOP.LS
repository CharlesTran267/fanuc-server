/PROG  EUREKA_MOVE_LOOP
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 919;
CREATE		= DATE 24-09-18  TIME 17:46:42;
MODIFIED	= DATE 24-09-20  TIME 23:58:04;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 43;
MEMORY_SIZE	= 1379;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
LOCAL_REGISTERS	= 0,0,0;
/APPL

AUTO_SINGULARITY_HEADER;
  ENABLE_SINGULARITY_AVOIDANCE   : FALSE;
/MN
   1:  F[100]=(OFF) ;
   2:  DO[512]=(ON) ;
   3:  LBL[1] ;
   4:  WAIT (F[100]=ON)    ;
   5:  F[100]=(OFF) ;
   6:  DO[512]=OFF ;
   7:  SELECT R[80]=1,JMP LBL[2] ;
   8:         =2,JMP LBL[3] ;
   9:         =0,JMP LBL[4] ;
  10:  LBL[2] ;
  11:  IF R[83]=0,JMP LBL[5] ;
  12:J PR[81] R[81]% CNT R[83] ACC R[82] DB R[83]mm,DO[512]=ON    ;
  13:  JMP LBL[1] ;
  14:  LBL[5] ;
  15:J PR[81] R[81]% FINE ACC R[82]    ;
  16:  DO[512]=ON ;
  17:  JMP LBL[1] ;
  18:  LBL[3] ;
  19:  IF R[83]=0,JMP LBL[6] ;
  20:L PR[81] R[81]mm/sec CNT R[83] ACC R[82] DB R[83]mm,DO[512]=ON    ;
  21:  JMP LBL[1] ;
  22:  LBL[6] ;
  23:L PR[81] R[81]mm/sec FINE ACC R[82]    ;
  24:  DO[512]=ON ;
  25:  JMP LBL[1] ;
  26:  LBL[4] ;
  27:  IF R[83]=0,JMP LBL[7] ;
  28:  R[87]=R[84]-1    ;
  29:  FOR R[85]=1 TO R[87] ;
  30:  R[86]=R[85]+80    ;
  31:J PR[R[86]] R[81]% CNT R[83] ACC R[82]    ;
  32:  ENDFOR ;
  33:  R[88]=R[84]+80    ;
  34:J PR[R[88]] R[81]% FINE ACC R[82]    ;
  35:  DO[512]=ON ;
  36:  JMP LBL[1] ;
  37:  LBL[7] ;
  38:  FOR R[85]=1 TO R[84] ;
  39:  R[86]=R[85]+80    ;
  40:J PR[81] R[81]% FINE ACC R[82]    ;
  41:  ENDFOR ;
  42:  DO[512]=ON ;
  43:  JMP LBL[1] ;
/POS
/END
