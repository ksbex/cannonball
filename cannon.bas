 100 REM === BASIC Month 3: Cannonball
 110 REM === http://reddit.com/r/RetroBattlestations
 120 REM === written by FozzTexx
 130 REM === TRS-80 Extended Color Basic version by CheapScotch

 200 REM === Clear screen and setup variables
 210 CLS
 220 CL = 32:RW = 16:REM Columns and Rows of screen
 230 CA = 45:CN = 5:REM Angle and length of cannon
 240 CX = 5:PX = CL-5:SC = 0:LV = 3
 250 PI = 3.14159

 300 REM === Play game
 310 CV = RND(15) + 10:GOSUB 4010:GOSUB 2010
 320 GOSUB 2510
 330 IF KE$ = "A" OR KE$ = "a" OR KE$ = CHR$(8) THEN CA = CA + 5:IF CA > 85 THEN CA = 85
 340 IF KE$ = "Z" OR KE$ = "z" OR KE$ = CHR$(21) THEN CA = CA - 5:IF CA < 15 THEN CA = 15
 350 IF KE$ = "Q" OR KE$ = "q" THEN END
 360 IF KE$ = " " THEN 410
 370 GOSUB 1010
 380 GOTO 320

 400 REM === Fire!
 410 LX = (CN + 1) * COS((360 - CA) * PI / 180):LY = (CN + 1) * SIN((360 - CA) * PI / 180)
 420 BX = CX + LX:BY = RW + LY
 430 GOSUB 1510
 440 VX = CV * COS((360 - CA) * PI / 180):VY = CV * SIN((360 - CA) * PI / 180)

 500 REM === Move player and animate ball
 510 GOSUB 2510
 520 IF KE$ = CHR$(8) THEN PX = PX - 1:IF PX < CX+CN THEN PX = CX+CN
 530 IF KE$ = CHR$(9) THEN PX = PX + 1:IF PX > CL - 1 THEN PX = CL -1
 540 GOSUB 2010
 550 BX = BX + (VX / 10):BY = BY + (VY / 10):GOSUB 1510
 560 VY = VY + 2
 570 IF BY < RW THEN 510
 580 P$=" ":N1=QX:M1=QY:GOSUB 3510

 600 REM === Score or die
 610 LX = BX - QX:LY = BY - QY:L2 = RW - QY
 620 N = QX + LX * (L2 / LY)
 630 IF N >= PX - 1 AND N <= PX + 1 THEN SC = SC + 10:GOTO 310
 640 LV = LV - 1:GOSUB 4010
 650 IF LV < 1 THEN P$="GAME OVER":N1 = (CL - LEN(P$)) / 2:M1 = RW / 2:GOSUB 3510:END
 660 GOTO 310
 
 1000 REM === Draw cannon
 1010 IF (CA = LA) THEN RETURN
 1020 P$="ANGLE:"+STR$(CA)+" ":N1=1:M1=1:GOSUB 3510
 1030 LX = CN * COS((360 - LA) * PI / 180):LY = CN * SIN((360 - LA) * PI / 180)
 1040 X1 = CX:Y1 = RW:X2 = X1 + LX:Y2 = Y1 + LY:P$ = " ":GOSUB 3010
 1050 LX = CN * COS((360 - CA) * PI / 180):LY = CN * SIN((360 - CA) * PI / 180)
 1060 X2 = X1 + LX:Y2 = Y1 + LY:P$= "%":GOSUB 3010
 1070 LA=CA:RETURN

 1500 REM === Draw ball
 1510 N1 = INT(BX):M1 = INT(BY):P$="o":GOSUB 3510
 1520 IF QX <> N1 OR QY <> M1 THEN N1=QX:M1=QY:P$=" ":GOSUB 3510
 1530 QX = INT(BX):QY = INT(BY)
 1540 RETURN

 2000 REM === Draw player
 2010 P$="U":N1 = PX:M1 =RW:GOSUB 3510
 2020 IF IPX <> N1 THEN N1=IPX:P$=" ":GOSUB 3510
 2030 IPX = INT(PX)
 2040 RETURN

 2500 REM === Read the keyboard
 2510 KE$ = INKEY$
 2520 RETURN

 3000 REM === Plot a line
 3010 N1 = INT(X1):N2 = INT(X2):M1 = INT(Y1):M2 = INT(Y2)
 3020 OX = ABS(N2 - N1):JX = -1:IF N1 < N2 THEN JX = 1
 3030 OY = ABS(M2 - M1):JY = -1:IF M1 < M2 THEN JY = 1
 3040 KR = -OY:IF OX > OY THEN KR = OX
 3050 KR = KR / 2
 3060 GOSUB 3510
 3070 IF N1 = N2 AND M1 = M2 THEN RETURN
 3080 K2 = KR
 3090 IF K2 > -OX THEN KR = KR - OY:N1 = N1 + JX
 3100 IF N1 = N2 AND M1 = M2 THEN RETURN
 3110 IF K2 < OY THEN KR = KR + OX:M1 = M1 + JY
 3120 IF N1 = N2 AND M1 = M2 THEN RETURN
 3130 GOTO 3060

 3500 REM === Plot a point
 3510 IF N1 < 1 OR N1 > CL OR M1 < 1 OR M1 > RW THEN RETURN
 3520 REM VTAB 1:PRINT:HTAB X1:VTAB Y1
 3530 PRINT @ ((M1-1)*32+N1-1), P$;
 3540 RETURN

 4000 REM === Show score/lives/velocity
 4010 P$="SPEED:"+STR$(CV)+" ":N1 = CL/3+1:M1=1:GOSUB 3510
 4020 P$="SCORE:"+STR$(SC):N1 = CL *2/3:GOSUB 3510
 4030 P$=MID$("   UUU",LV+1,3):N1=CL - 2:GOSUB 3510
 4040 RETURN
