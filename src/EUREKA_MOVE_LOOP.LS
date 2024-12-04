/PROG  EUREKA_MOVE_LOOP
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 3827;
CREATE		= DATE 24-09-18  TIME 17:46:42;
MODIFIED	= DATE 24-12-04  TIME 04:20:22;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 70;
MEMORY_SIZE	= 4307;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/APPL

AUTO_SINGULARITY_HEADER;
  ENABLE_SINGULARITY_AVOIDANCE   : FALSE;
/MN
   1:  --eg:General Idea of motion loop: ;
   2:  --eg:F[100] indicate whether there is a new target. Motion server is
    :  responsible for setting this flag on when there is a new target ;
   3:  --eg:DO[512] indicate whether the motion loop is ready to receive a new
    :  target ;
   4:  --eg:This loop will wait for Flag[100] to be turned ON by Motion Server
    :  and then proceed to turn OFF DO[512] indicating that it is executing a
    :  movement and execute the actual movement command. ;
   5:  --eg:After reaching the target or about to reach the target (depend on
    :  Distance Before value), this loop will turn DO[512] ON, indicating that
    :  it is ready to receive a new target ;
   6:  F[100]=(OFF) ;
   7:  DO[512]=(ON) ;
   8:  --eg:Motion loop start here. After finish executing a movement command or
    :  series of movement command (move trajectory), there should be commands
    :  to set DO[512] to ON and jump back to this label. ;
   9:  LBL[1] ;
  10:  --eg:Waiting for a new target to be sent. ;
  11:  WAIT (F[100]=ON)    ;
  12:  --eg:Setting both F[100] and DO[512] to be OFF, indicating that current
    :  target is executed and there is not new target. ;
  13:  F[100]=(OFF) ;
  14:  DO[512]=OFF ;
  15:  --eg:Wait for 100ms. Although this decrease the performance, this is
    :  necessary to address the case where the motion command return so fast
    :  that Karel program failed to detect if the current target is picked up
    :  by checking value of DO[512]. ;
  16:  WAIT    .01(sec) ;
  17:  --eg:R[80] is used to store motion type. 1 for MOVEJ, 2 for MOVEL, 3 for
    :  MOVE TRAJECTORY ;
  18:  --eg:PR[81] is used to target postion for MOVEJ, MOVEL and first target
    :  postion for MOVE TRAJECTORY ;
  19:  --eg:R[78], R[79], R[81], R[82] are used to store distance_before, CNT,
    :  speed, and acceleration respectively ;
  20:  --eg:The distance_before allow performing a certain action (in this case
    :  setting DO[512] to ON). This allow signal the loop is ready for next
    :  target even before finish ;
  21:  SELECT R[80]=1,JMP LBL[2] ;
  22:         =2,JMP LBL[3] ;
  23:         =0,JMP LBL[4] ;
  24:  --eg:MOVEJ ;
  25:  LBL[2] ;
  26:  --eg:This is to check if this is a FINE movement ;
  27:  IF R[79]=0,JMP LBL[5] ;
  28:J PR[81] R[81]% CNT R[79] ACC R[82] DB R[78]mm,DO[512]=ON    ;
  29:  JMP LBL[1] ;
  30:  --eg:MOVEJ with FINE movement ;
  31:  LBL[5] ;
  32:J PR[81] R[81]% FINE ACC R[82]    ;
  33:  DO[512]=ON ;
  34:  JMP LBL[1] ;
  35:  --eg:MOVEL. Note that for MOVEL, speed is specified in mm/sec instead of
    :  percentage like MOVEJ. An appropriate conversion to be done befor
    :  writng speed value to R[81] ;
  36:  LBL[3] ;
  37:  IF R[79]=0,JMP LBL[6] ;
  38:L PR[81] R[81]mm/sec CNT R[79] ACC R[82] DB R[78]mm,DO[512]=ON    ;
  39:  JMP LBL[1] ;
  40:  --eg:MOVEL with FINE movement ;
  41:  LBL[6] ;
  42:L PR[81] R[81]mm/sec FINE ACC R[82]    ;
  43:  DO[512]=ON ;
  44:  JMP LBL[1] ;
  45:  --eg:MOVE TRAJECTORY ;
  46:  --eg:For MOVE TRAJECTORY, all targets position are set before executing
    :  any movement. The first target is stored in R[81], second is stored in
    :  R[82] and so on. ;
  47:  --eg:R[84] is used to store number of targets to execute ;
  48:  LBL[4] ;
  49:  IF R[79]=0,JMP LBL[7] ;
  50:  --eg:R[87] is used to store number of targets-1. This is to allow a for
    :  loop from first point to next last point. As the last point has to be
    :  executed in FINE fashion. ;
  51:  R[87]=R[84]-1    ;
  52:  --eg:R[85] act like a iterator index ;
  53:  FOR R[85]=1 TO R[87] ;
  54:  --eg:R[86] is used to store the index of the postion register that store
    :  the target of current iteration. As the first target is stored at
    :  PR[81] so we add 80 to R[85] here ;
  55:  R[86]=R[85]+80    ;
  56:J PR[R[86]] R[81]% CNT R[79] ACC R[82]    ;
  57:  ENDFOR ;
  58:  --eg:R[88] is used to store the index of position register that store the
    :  last point ;
  59:  R[88]=R[84]+80    ;
  60:J PR[R[88]] R[81]% FINE ACC R[82]    ;
  61:  DO[512]=ON ;
  62:  JMP LBL[1] ;
  63:  --eg:MOVE TRAJECTORY but every point is a FINE movement ;
  64:  LBL[7] ;
  65:  FOR R[85]=1 TO R[84] ;
  66:  R[86]=R[85]+80    ;
  67:J PR[81] R[81]% FINE ACC R[82]    ;
  68:  ENDFOR ;
  69:  DO[512]=ON ;
  70:  JMP LBL[1] ;
/POS
/END
