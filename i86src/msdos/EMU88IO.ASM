	page 66, 200
       TITLE   IO.SYS for the EMU8088/V20

; I/O system for Version 2.x of MSDOS.

;This BIOS designed to be linked with the SYSINIT module provided by
;Microsoft

BIOSIZ  EQU     0C00H           ;MSDOS.SYS loading location( except INT vector )
				;MSDOS.SYS in Sector location = 6 (IO.SYS size = 6*200H=C00H)
				;BIOSIZ = MSDOS.SYS in Sector location = 0C00H
				;INT Vector area size =400H.
				;real MSDOS.SYS loading location in MEMORY at 400H + C00H = 1000H
BIOSIZS EQU     BIOSIZ/10H      ;MSDOS.SYS loading Paragraphs. 0C0H
ANSI    EQU     0               ;Ansi switch.

;Additional Information for the EMU8088 machine.

QSIZE   EQU     100             ;Input queue size.
BIOSSEG EQU     40H             ;I/O system segment.(IO.SYS segment)
;MAX_MEM EQU     0A000H          ;Memory size in paragraphs. (640K)
MAX_MEM EQU     07F00H          ;Memory size in paragraphs. (508K)
uni_seg	equ	07f50h		;unimon code segment
sysinit_ss	equ	MAX_MEM	;sysinit initial stack segment
sysinit_sp	equ	100h	; sysinit initial stack offset

DREQ_COM	equ	0006h	; device request command
PTRSAV_OFF	equ	0008h	; request header address save offset
PTRSAV_SEG	equ	000ah	; request header segment save offset

PIC_IO		equ	0	; Address where PIC F/W is booted

DRVMAX		equ	4

;Things needed to communicate with SYSINIT

EXTRN   SYSINIT:FAR                   ;The entry point of SYSINIT
EXTRN   CURRENT_DOS_LOCATION:WORD     ;Where the DOS is when SYSINIT called
EXTRN   FINAL_DOS_LOCATION:WORD       ;Where I want SYSINIT to put the DOS
EXTRN   DEVICE_LIST:DWORD             ;Pointer to the DEVICE list.
EXTRN   MEMORY_SIZE:WORD              ;Size in paragraphs of Physical memory.
EXTRN   DEFAULT_DRIVE:BYTE            ;Default Drive to use when system booted
EXTRN   BUFFERS:BYTE                  ;Number of default buffers.

        PAGE
        SUBTTL  Cold start jump

CODE    SEGMENT
ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE

        ORG     0               ;Starts at an offset of zero.

INIT:   JMP     HWINIT

        PAGE
        SUBTTL  BOOT sector definition

DPB     STRUC		; BOOT sector definition

JMPNEAR DB      3 DUP (?)       ;Jmp Near xxxx  for boot.
NAMEVER DB      8 DUP (?)       ;Name / Version of OS.

;-------  Start of Drive Parameter Block. (or also known as BPB:Bios Parameter Block)

SECSIZE DW      ?               ;Sector size in bytes.                  (dpb)
ALLOC   DB      ?               ;Number of sectors per alloc. block.    (dpb)
RESSEC  DW      ?               ;Reserved sectors.                      (dpb)
FATS    DB      ?               ;Number of FAT's.                       (dpb)
MAXDIR  DW      ?               ;Number of root directory entries.      (dpb)
SECTORS DW      ?               ;Number of sectors per diskette.        (dpb)
MEDIAID DB      ?               ;Media byte ID.                         (dpb)
FATSEC  DW      ?               ;Number of FAT Sectors.                 (dpb)

;-------  End of Drive Parameter Block.

SECTRK  DW      ?               ;Number of Sectors per track.

DPB     ENDS

; DPB and pointer are initialized
;
INITTAB:
        DW	DSKA.SECSIZE
        DW	DSKB.SECSIZE
        DW	DSKC.SECSIZE
        DW	DSKD.SECSIZE

DSKA DPB <,,,,,,,,,,>
DSKB DPB <,,,,,,,,,,>
DSKC DPB <,,,,,,,,,,>
DSKD DPB <,,,,,,,,,,>

        PAGE

        SUBTTL  Device driver tables.

;-----------------------------------------------+
;     DWORD pointer to next device              | 1 word offset.
;         (-1,-1 if last device)                | 1 word segement.
;-----------------------------------------------+
;     Device attribute WORD                     ; 1 word.
;       Bit 15 = 1 for chacter devices.         ;
;                0 for Block devices.           ;
;                                               ;
;       Charcter devices. (Bit 15=1)            ;
;         Bit 0 = 1  current sti device.        ;
;         Bit 1 = 1  current sto device.        ;
;         Bit 2 = 1  current NUL device.        ;
;         Bit 3 = 1  current Clock device.      ;
;                                               ;
;         Bit 13 = 1 for non IBM machines.      ;
;                  0 for IBM machines only.     ;
;         Bit 14 = 1 IOCTL control bit.         ;
;-----------------------------------------------+
;     Device strategy pointer.                  ; 1 word offset.
;-----------------------------------------------+
;     Device interrupt pointer.                 ; 1 word offset.
;-----------------------------------------------+
;     Device name field.                        ; 8 bytes.
;       Character devices are any valid name    ;
;         left justified, in a space filled     ;
;         field.                                ;
;       Block devices contain # of units in     ;
;         the first byte.                       ;
;-----------------------------------------------+

; Device Header

DEVSTART LABEL WORD
CONDEV:                         ;Header for device CON
        DW      AUXDEV,BIOSSEG  ;Link to next device
        DW      8003H           ;Attributes - console input, output device
        DW      STRATEGY        ;Srategy entry point
        DW      CON_INT         ;Interrupt entry point
        DB      "CON     "      ;Device name

AUXDEV:                         ;Header for device AUX
        DW      PRNDEV,BIOSSEG
        DW      8000H
        DW      STRATEGY
        DW      AUX_INT
        DB      "AUX     "

PRNDEV:                         ;Header for device PRN
        DW      TIMDEV,BIOSSEG
        DW      8000H
        DW      STRATEGY
        DW      PRN_INT
        DB      "PRN     "

TIMDEV:                         ;Header for device CLOCK
        DW      DSKDEV,BIOSSEG
        DW      8008H
        DW      STRATEGY
        DW      TIM_INT
        DB      "CLOCK   "

DSKDEV:                         ;Header for disk devices
        DW      -1,-1           ;Last device
        DW      2000H           ;Is a block device
        DW      STRATEGY
        DW      DSK_INT         ;Interrupt entry point
	DB      DRVMAX          ;Number of Units
        DB      7 DUP (?)

        PAGE
        SUBTTL  Strategy and Software Interrupt routines.

;Define offsets for io data packet

IODAT   STRUC
CMDLEN  DB      ?               ;LENGTH OF THIS COMMAND
UNIT    DB      ?               ;SUB UNIT SPECIFIER
CMD     DB      ?               ;COMMAND CODE
STATUS  DW      ?               ;STATUS
        DB      8 DUP (?)
MEDIA   DB      ?               ;MEDIA DESCRIPTOR
TRANS   DD      ?               ;TRANSFER ADDRESS
COUNT   DW      ?               ;COUNT OF BLOCKS OR CHARACTERS
START   DW      ?               ;FIRST BLOCK TO TRANSFER
IODAT   ENDS

PTRSAV  DD      0               ;Strategy pointer save.
;
; Simplistic Strategy routine for non-multi-Tasking system.
;
;   Currently just saves I/O packet pointers in PTRSAV for
;   later processing by the individual interrupt routines.
;

STRATP  PROC    FAR

        PUBLIC  RE_INIT

STRATEGY:
        MOV     WORD PTR CS:[PTRSAV],BX
        MOV     WORD PTR CS:[PTRSAV+2],ES

	; set request header pointer in the unimon
	push	ds
	push	ax
	mov	ax, uni_seg
	mov	ds, ax
        MOV     DS:[PTRSAV_OFF],BX
        MOV     DS:[PTRSAV_SEG],ES
	pop	ax
	pop	ds

RE_INIT:
        RET

STRATP  ENDP

AUX_INT:
	push	si
	mov	si, 0010h	; set device code
	jmp	ENTRY

PRN_INT:
	push	si
	mov	si, 0020h	; set device code
	jmp	ENTRY

TIM_INT:
	push	si
	mov	si, 0030h	; set device code
	jmp	ENTRY

CON_INT:
	push	si
	mov	si, 0040h	; set device code
	jmp	ENTRY

DSK_INT:
	push	si
	mov	si, 0050h	; set device code

ENTRY:  PUSH    AX              ;Save all nessacary registers.
        PUSH    CX
        PUSH    DX
        PUSH    DI
        PUSH    BP
        PUSH    DS
        PUSH    ES
        PUSH    BX

	mov	ax, uni_seg
	mov	ds, ax
	
	mov	ax, si
	mov	DS:[DREQ_COM], al

	lds	si, cs:[PTRSAV]
	mov	ax,[si.STATUS]
	and	ax, 1111111011111111b	; clear done bit
	mov	[si.STATUS],ax

	out	PIC_IO, al		; invoke PIC F/W
					; out port address and data is DUMMY!
wait_done:
	mov	ax,[si.STATUS]
	test	ax, 0000000100000000b	; check done bit
	jz	wait_done

	test	ah, 10000000b	; check error
	jnz	err_done
	xor	al, al
err_done:

EXITP   PROC    FAR             ;Normal exit for device drivers.

        POP     BX              ;Restore registers.
        POP     ES
        POP     DS
        POP     BP
        POP     DI
        POP     DX
        POP     CX
        POP     AX
        POP     SI
        RET                             ;RESTORE REGS AND RETURN
EXITP   ENDP

IF      ANSI

        SUBTTL  ANSI interface section.

;
;ANSI Info and routines. ANSI driver implemented as a finite state automata
;This ANSI driver translates the ANSI standard escape sequences into the
; Zenith Escape sequences used on the Zenith(Heath) Z(H)-19 terminal.
;This is not a full implementation of ANSI, but rather a minimal implementation
; which implements all of the necessary ANSI functions.
;

ESC     EQU     1BH             ;Escape character used in this implementation.
STATE   DW      ST1             ;Current ANSI character state.
PRMPNT  DW      PARMS           ;Current parameter pointer.
PARMS   DB      0,0,0,0,0,0,0   ;Allow for up to eight parameters.
LASTPRM DB      0               ;With this being the eight one.

CMDTABL DB      'A'             ;Cursor up.  "esc","[",#,"A"
        DW      CUU
        DB      'B'             ;Cursor down. "esc","[",#,"B"
        DW      CUD
        DB      'C'             ;Cursor forward. "esc","[",#,"C"
        DW      CUF
        DB      'D'             ;Cursor back. "esc","[",#,"D"
        DW      CUB
        DB      'H'             ;Direct cursor posit. "esc","[",x,y,"H"
        DW      CUP
        DB      'J'             ;Erase. "esc","[",code,"J"
        DW      ED
        DB      'K'             ;Erase in line. "esc","[",code,"K"
        DW      EL
        DB      'f'             ;Direct cursor posit. "esc","[",x,y,"f"
        DW      CUP
        DB      'm'             ;Special video mode. "esc","[",code,"m"
        DW      SGR
        DB      's'             ;Save cursor posit. "esc","[","s"
        DW      PSCP
        DB      'u'             ;Move cursor to saved. "esc","[","u"
        DW      PRCP
        DB      00              ;End of table.

;
; ANSI console output driver.
;

CONOUT: MOV     DI,OFFSET STATE ;Retrieve current ansi state.
        JMP     [DI]            ;Jump to it.

;
; State one (1).
;   Looks for an Escape character.
;

ST1:    CMP     AL,ESC          ;See if this the first character is ESC.
        JNZ     OUTCHR          ;No, treat as regular character output.
        MOV     WORD PTR [DI],OFFSET ST2        ;Yes, setup state two.
        RET

;
; State two (2).
;   Looks for the "[" character.
;

ST2:    CMP     AL,'['          ;See if a valide state two.
        JNZ     OUTCHR          ;No, treat as regular charcter
        MOV     BX,OFFSET PARMS ;Yes, get parameter pointer.
        MOV     WORD PTR [PRMPNT],BX    ;Setup in pointer index.
        MOV     WORD PTR [BX],0 ;Clear first entry.
        MOV     WORD PTR [DI],OFFSET ST3;Setup for state three.
        RET

;
; State three (3).
;   Entered one or more times for parameter passing.
;

ST3:    CMP     AL,';'          ;Look for decimal # seperator.
        JNZ     ST3A            ;No check phase A.
        INC     WORD PTR [PRMPNT]       ;Yes, incr. pointer to next param.
        MOV     AX,OFFSET LASTPRM       ;Check for outside parameter list.
        CMP     [PRMPNT],AX
        JBE     RETST3          ;Yes, proceed with next parameter.
        MOV     [PRMPNT],AX     ;No, treat as extentsion to old.
RETST3: MOV     DI,[PRMPNT]     ;Setup for next parameter.
        MOV     BYTE PTR [DI],0 ;Pre-Initialize it to zero.
        RET

;
; State three A (3A).
;   Check for a ascii digit.
;

ST3A:   CMP     AL,'0'          ;Check for ASCII digit.
        JB      ST3B            ;No, check for seconday command character.
        CMP     AL,'9'          ;Still checking for ASCII digit.
        JA      ST3B            ;No, it must be a secondary.
        SUB     AL,'0'          ;Convert to binary.
        MOV     DI,[PRMPNT]     ;Get the current parameter pointer.
        XCHG    [DI],AL         ;Get existing #.
        MOV     AH,10           ;Scale by 10.
        MUL     AH
        ADD     [DI],AL         ;Add to new digit.
        RET

;
; State three B (3B).
;   Wasn't a ascii digit, so check for secondary command.
;

ST3B:   MOV     [DI],OFFSET ST1         ;Preset STATE to state 1 just in case.
        MOV     DI,OFFSET PARMS-1       ;Get pointer to start of parameters.
        MOV     [PRMPNT],DI             ;Save it in Parameter pointer.
        MOV     DI,OFFSET CMDTABL-3     ;Get start of Secondary command table.

ST3B1:  ADD     DI,3            ;Update Command table pointer.
        CMP     BYTE PTR [DI],0 ;Check for end of table.
        JNZ     ST3B2           ;No, continue processing.
        JMP     OUTCHR          ;Yes, treat as regular character.
ST3B2:  CMP     AL,[DI]         ;Check for valid. command.
        JNZ     ST3B1           ;No, keep checking.
        JMP     [DI+1]          ;Yes, transfer to that secondary command.

;
; Get binary parameter from storage and return a one if = 0
;

GETONE: CALL    GETPARM         ;Get parameter form list.
        OR      AL,AL           ;Verify for non-zero.
        JNZ     GETRET          ;Good, then return to caller.
        INC     AL              ;Bad, make it at least a one.
GETRET: CBW                     ;Sign extend AL.
        MOV     CX,AX           ;Copy of it to CX.
        RET

GETPARM:INC     WORD PTR [PRMPNT]       ;Increment parameter pointer.
GOTPARM:MOV     DI,[PRMPNT]     ;Get parameter pointer.
        MOV     AL,[DI]         ;Get parameter value.
        RET

;
; Send escape, character sequence.
;

OUTESC: MOV     AL,ESC          ;Send escape character.
        CALL    OUTCHR
        MOV     AL,BL           ;Send follow character.
        JMP     OUTCHR

;
; Cursor Positioning routines.
;

CUU:    MOV     BL,'A'          ;Cursor up.
        JMP     SHORT CURPOS
CUD:    MOV     BL,'B'          ;Cursor down.
        JMP     SHORT CURPOS
CUF:    MOV     BL,'C'          ;Cursor forward.
        JMP     SHORT CURPOS
CUB:    MOV     BL,'D'          ;Cursor back.

CURPOS: CALL    GETONE          ;Get number of positions to move into CX.
MOVCUR: CALL    OUTESC          ;Send escape, command characters.
        LOOP    MOVCUR          ;Keep moving until done.
        RET

;
; Direct cursor positioning routine.
;

CUP:    CALL    GETONE          ;Get X position.
        MOV     DX,AX           ;Save in DX.
        CALL    GETONE          ;Get Y position.
        MOV     BL,'Y'
        CALL    OUTESC          ;Send escape, "Y" sequence.
        MOV     AL,DL
        ADD     AL,' '-1        ;Convert binary to Character.
        CALL    OUTCHR          ;Send X posit.
        MOV     AL,CL
        ADD     AL,' '-1        ;Convert binary to Character.
        JMP     OUTCHR          ;Send Y posit.

;
; Erase all/part of screen.
;

ED:     CALL    GETPARM         ;Get trinary command type.
        MOV     BL,'b'
        DEC     AL              ;See if erase from begining of screen.
        JZ      ED1             ;Yes, perform ZDS function.
        MOV     BL,'E'
        DEC     AL              ;See if erase from end of screen.
        JZ      ED1             ;Yes, perform ZDS function.
        MOV     BL,'J'          ;Now we assume erase whole screen.
ED1:    JMP     OUTESC

;
; Erase all/part of a line.
;

EL:     CALL    GETPARM         ;Get trinary command type.
        MOV     BL,'o'
        DEC     AL              ;See if erase from begining of line.
        JZ      EL1             ;Yes, perform ZDS function.
        MOV     BL,'l'
        DEC     AL              ;See if erase whole line.
        JZ      EL1             ;Yes, perform ZDS function.
        MOV     BL,'K'          ;Now we assume erase to end of line.
EL1:    JMP     OUTESC

;
; Special video modes.
;

SGR:    CALL    GETPARM         ;Get trinary command type.
        MOV     BL,'p'
        CMP     AL,7            ;See if enter reverse video mode.
        JZ      SGR2            ;Yes, perform ZDS function.
        MOV     BL,'q'
        OR      AL,AL           ;See if exit reverse video mode.
        JNZ     SGR3            ;No, ignore.
SGR2:   CALL    OUTESC
SGR3:   RET

;
; Save / restore cursor position.
;

PSCP:   MOV     BL,'j'          ;Set save cursor posit. mode.
        JMP     OUTESC

PRCP:   MOV     BL,'k'          ;Restore last cursor save.
        JMP     OUTESC

        ENDIF			; ANSI


        PAGE
        SUBTTL  Initalization code and temporary work areas.

;
; Overlayed by MSDOS by SYSINIT.
;

WRKSTK  LABEL   WORD
        DB      100 DUP (?)


HWINIT: mov     BP, sysinit_ss		; MEMORY FF00:0 - FF20:0 : free space(FF30:0 - used unimon)
        MOV     SS,BP
        MOV     SP, sysinit_sp		;Some nice area for stack. (free area in EMU8088/V20)
					;ss:sp=FF00:0100H
        PUSH    CS
        POP     ES
        MOV     AX,SEG SYSINIT
        MOV     DS,AX

ASSUME  DS:SEG SYSINIT

        MOV     AX,CS				; CS: IO.SYS segment (40H)
        ADD     AX,BIOSIZS			; C0H
        MOV     DS:[CURRENT_DOS_LOCATION],AX	; save C0H+40H = 100H
        MOV     DS:[MEMORY_SIZE],MAX_MEM	; save FF00H
        MOV     AX,CS
        MOV     WORD PTR DS:[DEVICE_LIST+2],AX	;		; save device headder segment(40H)
        MOV     WORD PTR DS:[DEVICE_LIST],OFFSET DEVSTART	; save device hedder offset
;        MOV     AX,CS
        ADD     AX,((OFFSET WRKSTK - OFFSET INIT)+50) /16
        MOV     DS:[FINAL_DOS_LOCATION],AX			; set MSDOS.SYS entory point(final location)
        JMP     SYSINIT

DOSSPOT LABEL   WORD

CODE    ENDS

        END
