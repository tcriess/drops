; faster dot routines

; screen address table (160-bytes-steps) in a2 (already contains the 2-bytes-per-plane offset)
; x-coordinate in d0
; y-coordinate in d1
; destroys d0,d1,d2,a2,a3
    text
dot1x1:
    move.w d0,d2 ; save x  4 (1/0) 2
    lsr.w #1,d2 ; /2  8 (1/0) 2
    andi.w #$fff8,d2 ; mask out bit 0-2  8 (2/0) 4
    add.w d1,d1 ; 4 (1/0) 2
    add.w d1,d1 ; d1 = y * 4  4 (1/0) 2
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line  18 (4/0) 4
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles  8 (1/0) 2
    andi.w #$000f,d0 ; shift  8 (2/0) 4
    lsl.w #3,d0 ; *8 8 bytes per routine  12 (1/0) 2
    lea.l dot1x1_x0(pc),a0 ; a0 = dot routine 0  8 (2/0) 4
    adda.w d0,a0  8 (1/0) 2
    jmp (a0) ; jump to correct dot routine  8 (2/0) 2
dot1x1_p2:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l (a2,d1.w),a3 ; a3 = screen address beginning of line
    addq #2,a3 ; 2nd plane
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #3,d0 ; *8 8 bytes per routine
    lea.l dot1x1_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    jmp (a0) ; jump to correct dot routine
dot1x1_x0:
    ori.w #$8000,(a3) ; 4 bytes  16 (3/1) 4
    rts ; 2 bytes  16 (4/0) 2
    ; total cycle count: 126
    nop ; 2 bytes
dot1x1_x1:
    ori.w #$4000,(a3)
    rts
    nop
dot1x1_x2:
    ori.w #$2000,(a3)
    rts
    nop
dot1x1_x3:
    ori.w #$1000,(a3)
    rts
    nop
dot1x1_x4:
    ori.w #$0800,(a3)
    rts
    nop
dot1x1_x5:
    ori.w #$0400,(a3)
    rts
    nop
dot1x1_x6:
    ori.w #$0200,(a3)
    rts
    nop
dot1x1_x7:
    ori.w #$0100,(a3)
    rts
    nop
dot1x1_x8:
    ori.w #$0080,(a3)
    rts
    nop
dot1x1_x9:
    ori.w #$0040,(a3)
    rts
    nop
dot1x1_x10:
    ori.w #$0020,(a3)
    rts
    nop
dot1x1_x11:
    ori.w #$0010,(a3)
    rts
    nop
dot1x1_x12:
    ori.w #$0008,(a3)
    rts
    nop
dot1x1_x13:
    ori.w #$0004,(a3)
    rts
    nop
dot1x1_x14:
    ori.w #$0002,(a3)
    rts
    nop
dot1x1_x15:
    ori.w #$0001,(a3)
    rts
    nop

; screen address table (160-bytes-steps) in a2 (already contains the 2-bytes-per-plane offset)
; x-coordinate in d0
; y-coordinate in d1
; destroys d0,d1,d2,a2,a3
dot2x2:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #4,d0 ; *16 16 bytes per routine
    lea.l dot2x2_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    jmp (a0) ; jump to correct dot routine
dot2x2_p2:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line
    addq #2,a3 ; 2nd plane
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #4,d0 ; *16 16 bytes per routine
    lea.l dot2x2_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    jmp (a0) ; jump to correct dot routine
dot2x2_x0:
    ori.w #$C000,(a3) ; 4 bytes
    ori.w #$C000,160(a3) ; 6 bytes
    rts ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot2x2_x1:
    ori.w #$6000,(a3)
    ori.w #$6000,160(a3)
    rts
    nop
    nop
dot2x2_x2:
    ori.w #$3000,(a3)
    ori.w #$3000,160(a3)
    rts
    nop
    nop
dot2x2_x3:
    ori.w #$1800,(a3)
    ori.w #$1800,160(a3)
    rts
    nop
    nop
dot2x2_x4:
    ori.w #$0C00,(a3)
    ori.w #$0C00,160(a3)
    rts
    nop
    nop
dot2x2_x5:
    ori.w #$0600,(a3)
    ori.w #$0600,160(a3)
    rts
    nop
    nop
dot2x2_x6:
    ori.w #$0300,(a3)
    ori.w #$0300,160(a3)
    rts
    nop
    nop
dot2x2_x7:
    ori.w #$0180,(a3)
    ori.w #$0180,160(a3)
    rts
    nop
    nop
dot2x2_x8:
    ori.w #$00C0,(a3)
    ori.w #$00C0,160(a3)
    rts
    nop
    nop
dot2x2_x9:
    ori.w #$0060,(a3)
    ori.w #$0060,160(a3)
    rts
    nop
    nop
dot2x2_x10:
    ori.w #$0030,(a3)
    ori.w #$0030,160(a3)
    rts
    nop
    nop
dot2x2_x11:
    ori.w #$0018,(a3)
    ori.w #$0018,160(a3)
    rts
    nop
    nop
dot2x2_x12:
    ori.w #$000C,(a3)
    ori.w #$000C,160(a3)
    rts
    nop
    nop
dot2x2_x13:
    ori.w #$0006,(a3)
    ori.w #$0006,160(a3)
    rts
    nop
    nop
dot2x2_x14:
    ori.w #$0003,(a3)
    ori.w #$0003,160(a3)
    rts
    nop
    nop
dot2x2_x15:
    ori.w #$0001,(a3)  ; 4 bytes
    ori.w #$8000,8(a3) ; 6 bytes
    ori.w #$0001,160(a3)  ; 4 bytes
    ori.w #$8000,168(a3) ; 6 bytes
    rts

; screen address table (160-bytes-steps) in a2 (already contains the 2-bytes-per-plane offset)
; x-coordinate in d0
; y-coordinate in d1
; destroys d0,d1,d2,a0,a2,a3,a4
dot3x3:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #5,d0 ; *32 32 bytes per routine
    lea.l dot3x3_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    lea.l 160(a3),a4
    lea.l 320(a3),a2
    jmp (a0) ; jump to correct dot routine
dot3x3_p2:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line
    addq #2,a3 ; 2nd plane
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #5,d0 ; *32 32 bytes per routine
    lea.l dot3x3_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    lea.l 160(a3),a4
    lea.l 320(a3),a2
    jmp (a0) ; jump to correct dot routine
dot3x3_x0:
    ori.w #$4000,(a3) ; 4 bytes
    ori.w #$E000,(a4) ; 4 bytes
    ori.w #$4000,(a2) ; 4 bytes
    rts ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x1:
    ori.w #$2000,(a3)
    ori.w #$7000,(a4)
    ori.w #$2000,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x2:
    ori.w #$1000,(a3)
    ori.w #$3800,(a4)
    ori.w #$1000,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x3:
    ori.w #$0800,(a3)
    ori.w #$1C00,(a4)
    ori.w #$0800,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x4:
    ori.w #$0400,(a3)
    ori.w #$0E00,(a4)
    ori.w #$0400,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x5:
    ori.w #$0200,(a3)
    ori.w #$0700,(a4)
    ori.w #$0200,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x6:
    ori.w #$0100,(a3)
    ori.w #$0380,(a4)
    ori.w #$0100,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x7:
    ori.w #$0080,(a3)
    ori.w #$01C0,(a4)
    ori.w #$0080,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x8:
    ori.w #$0040,(a3)
    ori.w #$00E0,(a4)
    ori.w #$0040,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x9:
    ori.w #$0020,(a3)
    ori.w #$0070,(a4)
    ori.w #$0020,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x10:
    ori.w #$0010,(a3)
    ori.w #$0038,(a4)
    ori.w #$0010,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x11:
    ori.w #$0008,(a3)
    ori.w #$001C,(a4)
    ori.w #$0008,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x12:
    ori.w #$0004,(a3)
    ori.w #$000E,(a4)
    ori.w #$0004,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x13:
    ori.w #$0002,(a3)
    ori.w #$0007,(a4)
    ori.w #$0002,(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot3x3_x14:
    ori.w #$0001,(a3) ; 4 bytes
    ori.w #$0003,(a4) ; 4 bytes
    ori.w #$8000,8(a4) ; 6 bytes
    ori.w #$0001,(a2) ; 4 bytes
    rts ; 2 bytes
    nop
    nop
    nop
    nop
    nop
    nop
dot3x3_x15: ; the last routine can be longer than 32 bytes
    ori.w #$8000,8(a3) ; 6 bytes
    ori.w #$0001,(a4)  ; 6 bytes
    ori.w #$C000,8(a4) ; 6 bytes
    ori.w #$8000,8(a2) ; 6 bytes
    rts

; screen address table (160-bytes-steps) in a2 (already contains the 2-bytes-per-plane offset)
; x-coordinate in d0
; y-coordinate in d1
; destroys d0,d1,d2,a0,a2,a3,a4
dot4x4:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #6,d0 ; *64 64 bytes per routine
    lea.l dot4x4_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    lea.l 160(a3),a4
    lea.l 320(a3),a2
    jmp (a0) ; jump to correct dot routine
dot4x4_p2:
    move.w d0,d2 ; save x
    lsr.w #1,d2 ; /2
    andi.w #$fff8,d2 ; mask out bit 0-2
    add.w d1,d1
    add.w d1,d1 ; d1 = y * 4
    move.l 0(a2,d1.w),a3 ; a3 = screen address beginning of line
    addq #2,a3 ; 2nd plane
    adda.w d2,a3 ; a3 = screen address beginning of line + correct x address 8 cycles
    andi.w #$000f,d0 ; shift
    lsl.w #5,d0 ; *32 32 bytes per routine
    lea.l dot4x4_x0(pc),a0 ; a0 = dot routine 0
    adda.w d0,a0
    lea.l 160(a3),a4
    lea.l 320(a3),a2
    jmp (a0) ; jump to correct dot routine
dot4x4_x0:
    ori.w #$6000,(a3) ; 4 bytes
    ori.w #$F000,(a4) ; 4 bytes
    ori.w #$F000,(a2) ; 4 bytes
    ori.w #$6000,160(a2) ; 6 bytes
    rts ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x1:
    ori.w #$3000,(a3) ; 4 bytes
    ori.w #$7800,(a4) ; 4 bytes
    ori.w #$7800,(a2) ; 4 bytes
    ori.w #$3000,160(a2) ; 6 bytes
    rts ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x2:
    ori.w #$1800,(a3) ; 4 bytes
    ori.w #$3C00,(a4) ; 4 btes
    ori.w #$3C00,(a2) ; 4 bytes
    ori.w #$1800,160(a2) ; 6 bytes
    rts ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x3:
    ori.w #$0C00,(a3)
    ori.w #$1E00,(a4)
    ori.w #$1E00,(a2)
    ori.w #$0C00,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x4:
    ori.w #$0600,(a3)
    ori.w #$0F00,(a4)
    ori.w #$0F00,(a2)
    ori.w #$0600,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x5:
    ori.w #$0300,(a3)
    ori.w #$0780,(a4)
    ori.w #$0780,(a2)
    ori.w #$0300,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x6:
    ori.w #$0180,(a3)
    ori.w #$03C0,(a4)
    ori.w #$03C0,(a2)
    ori.w #$0180,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x7:
    ori.w #$00C0,(a3)
    ori.w #$01E0,(a4)
    ori.w #$01E0,(a2)
    ori.w #$00C0,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x8:
    ori.w #$0060,(a3)
    ori.w #$00F0,(a4)
    ori.w #$00F0,(a2)
    ori.w #$0060,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x9:
    ori.w #$0030,(a3)
    ori.w #$0078,(a4)
    ori.w #$0078,(a2)
    ori.w #$0030,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x10:
    ori.w #$0018,(a3)
    ori.w #$003C,(a4)
    ori.w #$003C,(a2)
    ori.w #$0018,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x11:
    ori.w #$000C,(a3)
    ori.w #$001E,(a4)
    ori.w #$001E,(a2)
    ori.w #$000C,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x12:
    ori.w #$0006,(a3)
    ori.w #$000F,(a4)
    ori.w #$000F,(a2)
    ori.w #$0006,160(a2)
    rts
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    rept 16
    nop ; 2 bytes * 16 = 32 bytes
    endr
dot4x4_x13:
    ori.w #$0003,(a3) ; 4 bytes
    ori.w #$0007,(a4) ; 4 bytes
    ori.w #$8000,8(a4) ; 6 bytes
    ori.w #$0007,(a2) ; 4 bytes
    ori.w #$8000,8(a2) ; 6 bytes
    ori.w #$0003,160(a2) ; 6 bytes
    rts ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
    nop ; 2 bytes
dot4x4_x14:
    ori.w #$0001,(a3) ; 4 bytes
    ori.w #$8000,8(a3) ; 6 bytes
    ori.w #$0003,(a4) ; 4 bytes
    ori.w #$C000,8(a4) ; 6 bytes
    ori.w #$0003,(a2) ; 4 bytes
    ori.w #$C000,8(a2) ; 6 bytes
    ori.w #$0001,160(a2) ; 6 bytes
    ori.w #$8000,168(a2) ; 6 bytes
    rts ; 2 bytes
    rept 10
    nop
    endr
dot4x4_x15: ; the last routine can be longer than 32 bytes
    ori.w #$C000,8(a3) ; 6 bytes
    ori.w #$0001,(a4)  ; 4 bytes
    ori.w #$E000,8(a4) ; 6 bytes
    ori.w #$0001,(a2)  ; 4 bytes
    ori.w #$E000,8(a2) ; 6 bytes
    ori.w #$C000,168(a2) ; 6 bytes
    rts ; 2 bytes
    rept 5
    nop
    endr

dot_subroutines:
    dc.l dot4x4,dot3x3,dot2x2,dot1x1