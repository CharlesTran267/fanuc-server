/PROG  EUREKA_MOVE_LOOP
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 3569;
CREATE		= DATE 24-09-18  TIME 17:46:42;
MODIFIED	= DATE 24-09-23  TIME 22:45:20;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 68;
MEMORY_SIZE	= 4057;
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
   1:  --eg:General Idea of motion loop: ;
   2:  --eg:F[100] indicate whether
    :  there is a new target. Motion
    :  server is responsible for
    :  setting this flag on when there
    :  is a new target ;
   3:  --eg:DO[512] indicate whether the
    :  motion loop is ready to receive
    :  a new target ;
   4:  --eg:This loop will wait for
    :  Flag[100] to be turned ON by
    :  Motion Server and then proceed
    :  to turn OFF DO[512] indicating
    :  that it is executing a movement
    :  and execute the actual movement
    :  command. ;
   5:  --eg:After reaching the target or
    :  about to reach the target
    :  (depend on Distance Before
    :  value), this loop will turn
    :  DO[512] ON, indicating that it
    :  is ready to receive a new
    :  target ;
   6:  F[100]=(OFF) ;
   7:  DO[512]=(ON) ;
   8:  --eg:Motion loop start here.
    :  After finish executing a
    :  movement command or series of
    :  movement command (move
    :  trajectory), there should be
    :  commands to set DO[512] to ON
    :  and jump back to this label. ;
   9:  LBL[1] ;
  10:  --eg:Waiting for a new target to
    :  be sent. ;
  11:  WAIT (F[100]=ON)    ;
  12:  --eg:Setting both F[100] and
    :  DO[512] to be OFF, indicating
    :  that current target is executed
    :  and there is not new target. ;
  13:  F[100]=(OFF) ;
  14:  DO[512]=OFF ;
  15:  --eg:R[80] is used to store
    :  motion type. 1 for MOVEJ, 2 for
    :  MOVEL, 3 for MOVE TRAJECTORY ;
  16:  --eg:PR[81] is used to target
    :  postion for MOVEJ, MOVEL and
    :  first target postion for MOVE
    :  TRAJECTORY ;
  17:  --eg:R[78], R[79], R[81], R[82]
    :  are used to store
    :  distance_before, CNT, speed,
    :  and acceleration respectively ;
  18:  --eg:The distance_before allow
    :  performing a certain action (in
    :  this case setting DO[512] to
    :  ON). This allow signal the loop
    :  is ready for next target even
    :  before finish ;
  19:  SELECT R[80]=1,JMP LBL[2] ;
  20:         =2,JMP LBL[3] ;
  21:         =0,JMP LBL[4] ;
  22:  --eg:MOVEJ ;
  23:  LBL[2] ;
  24:  --eg:This is to check if this is
    :  a FINE movement ;
  25:  IF R[79]=0,JMP LBL[5] ;
  26:J PR[81] R[81]% CNT R[79] ACC R[82] DB R[78]mm,DO[512]=ON    ;
  27:  JMP LBL[1] ;
  28:  --eg:MOVEJ with FINE movement ;
  29:  LBL[5] ;
  30:J PR[81] R[81]% FINE ACC R[82]    ;
  31:  DO[512]=ON ;
  32:  JMP LBL[1] ;
  33:  --eg:MOVEL. Note that for MOVEL,
    :  speed is specified in mm/sec
    :  instead of percentage like
    :  MOVEJ. An appropriate
    :  conversion to be done befor
    :  writng speed value to R[81] ;
  34:  LBL[3] ;
  35:  IF R[79]=0,JMP LBL[6] ;
  36:L PR[81] R[81]mm/sec CNT R[79] ACC R[82] DB R[78]mm,DO[512]=ON    ;
  37:  JMP LBL[1] ;
  38:  --eg:MOVEL with FINE movement ;
  39:  LBL[6] ;
  40:L PR[81] R[81]mm/sec FINE ACC R[82]    ;
  41:  DO[512]=ON ;
  42:  JMP LBL[1] ;
  43:  --eg:MOVE TRAJECTORY ;
  44:  --eg:For MOVE TRAJECTORY, all
    :  targets position are set before
    :  executing any movement. The
    :  first target is stored in
    :  R[81], second is stored in
    :  R[82] and so on. ;
  45:  --eg:R[84] is used to store
    :  number of targets to execute ;
  46:  LBL[4] ;
  47:  IF R[79]=0,JMP LBL[7] ;
  48:  --eg:R[87] is used to store
    :  number of targets-1. This is to
    :  allow a for loop from first
    :  point to next last point. As
    :  the last point has to be
    :  executed in FINE fashion. ;
  49:  R[87]=R[84]-1    ;
  50:  --eg:R[85] act like a iterator
    :  index ;
  51:  FOR R[85]=1 TO R[87] ;
  52:  --eg:R[86] is used to store the
    :  index of the postion register
    :  that store the target of
    :  current iteration. As the first
    :  target is stored at PR[81] so
    :  we add 80 to R[85] here ;
  53:  R[86]=R[85]+80    ;
  54:J PR[R[86]] R[81]% CNT R[79] ACC R[82]    ;
  55:  ENDFOR ;
  56:  --eg:R[88] is used to store the
    :  index of position register that
    :  store the last point ;
  57:  R[88]=R[84]+80    ;
  58:J PR[R[88]] R[81]% FINE ACC R[82]    ;
  59:  DO[512]=ON ;
  60:  JMP LBL[1] ;
  61:  --eg:MOVE TRAJECTORY but every
    :  point is a FINE movement ;
  62:  LBL[7] ;
  63:  FOR R[85]=1 TO R[84] ;
  64:  R[86]=R[85]+80    ;
  65:J PR[81] R[81]% FINE ACC R[82]    ;
  66:  ENDFOR ;
  67:  DO[512]=ON ;
  68:  JMP LBL[1] ;
/POS
/END
