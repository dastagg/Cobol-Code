      ***********************************************************
      * Program name:    VSCBEX03
      * Original author: dastagg
      *
      *    Description: Example 03: Indexed File Processing: 
      *                 Read Random
      *    This program will load 5 Keys from a table and randomly read 
      *       the records from an indexed file opened:
      *       ACCESS MODE IS RANDOM
      *       OPEN INPUT
      *
      *    The same program will run on both GnuCOBOL and ZOS COBOL.
      *    The only change is the ASSIGN TO statement.
      *
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-20 dastagg       Created to learn.
      * 2020-08-20 dastagg       If you change me, change this.

      ***********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VSCBEX03.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTFile
           ASSIGN TO "../idata/customer.idat"       
           ORGANIZATION IS INDEXED
           RECORD KEY IS CUSTFile-Cust-ID
           ACCESS MODE IS RANDOM
           FILE STATUS IS WS-CUSTFile-Status.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTFile.
           COPY CUSTOMER REPLACING ==:tag:== BY ==CUSTFile==.

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           COPY WSFST REPLACING ==:tag:== BY ==CUSTFile==.

       01  WS-File-Counters.
           12 FD-CUSTFile-Record-Cnt         PIC S9(4) COMP VALUE ZERO.
         
       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program VSCBEX03 - End of Run Messages".

       01  WS-Key-HOLD.
           12 FILLER PIC 9(4) VALUE 0010.
           12 FILLER PIC 9(4) VALUE 0420.
           12 FILLER PIC 9(4) VALUE 0878.
           12 FILLER PIC 9(4) VALUE 0210.
           12 FILLER PIC 9(4) VALUE 0998.

       01  WS-Key-Table-Storage.
           12 WS-Key-Element-Cnt               PIC 9 VALUE 5.
           12 WS-Key-SUB                       PIC 9 VALUE 0.
           12 WS-Key-Table-Setup.
              15 WS-Key-Table OCCURS 5 TIMES.
                18 WS-Key-Value                PIC 9(04).

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           MOVE WS-Key-HOLD  TO WS-Key-Table-Setup.
           OPEN INPUT CUSTFile.
      D    DISPLAY "CUSTFile Open Status: " WS-CUSTFile-Status.

       2000-Process.
           PERFORM VARYING WS-Key-SUB FROM 1 BY 1
              UNTIL WS-Key-SUB > WS-Key-Element-Cnt
              MOVE WS-Key-Value(WS-Key-SUB) TO
                 CUSTFile-Cust-ID
              PERFORM 5000-Read-CUSTFile
              DISPLAY "CUSTFile Record: " CUSTFile-Customer-Record
           END-PERFORM.

       3000-End-Job.
           DISPLAY EOJ-End-Message.
           DISPLAY "   Records Read: " FD-CUSTFile-Record-Cnt
           CLOSE CUSTFile.
      D    DISPLAY "CUSTFile Close Status: " WS-CUSTFile-Status.

       5000-Read-CUSTFile.
           READ CUSTFile
              RECORD KEY IS CUSTFile-Cust-ID
           END-READ.
           IF WS-CUSTFile-Good
              ADD +1 TO FD-CUSTFile-Record-Cnt
      D       DISPLAY "CUSTFile Record: " CUSTFile-Customer-Record
           ELSE
              IF WS-CUSTFile-EOF
                 NEXT SENTENCE
              ELSE
                 DISPLAY "** ERROR **: 5000-Read-CUSTFile"
                 DISPLAY "Read CUSTFile Failed."
                 DISPLAY "File Status: " WS-CUSTFile-Status
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK 
              END-IF
           END-IF.
