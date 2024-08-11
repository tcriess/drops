; interrupts
; vertical blank interrupt routine
    text
vbl:
    movem.l d0-d7/a0-a6,-(sp)
    
    move.w global_frame_cnt,d0
    addq #1,d0
    cmp.w #play_secs*50,d0
    bgt quitvbi
    move.w d0,global_frame_cnt

    cmp.w sound_delay,d0
    blt.s nosound
    jsr     music+8                 ; call music
nosound:

    move.l next_pal,a0
    movem.l (a0),d0-d7
    movem.l d0-d7,$ffff8240.w

    ; move.b #0,$fffffa1b.w ; timer anhalten
    ; move.b distanz,$fffffa21.w ; datenregister setzen
    ; move.b #8,$fffffa1b.w ; timer starten
    ; movem.l palette,d0-d7
    ; movem.l d0-d7,$ffff8240.w
    ; move.l palstart,pal
    ; move.l disstart,dis
    ; addq.l #1,dis
    ; add.l #32,pal

    movea.l screen,a0
    jsr     clr_scr_fast

    lea     coord_diffs,a1
    ; each entry in coord_diffs corresponds to
    ; screen x,y,z of the lower left front coordinate
    ; x,y,z deltas for the next coordinate in x direction
    ; x,y,z deltas for the next coordinate in y direction
    ; x,y,z deltas for the next coordinate in z direction
    ; i.e. 24 bytes, repeated for combinations of angels
    ; starting with alpha = 15, beta = 0, 5, ..., 45; alpha = 20, beta = 0, 5, ..., 45
    move.l curr_pos_in_ang_seq,a5
    move.w (a5)+,d7 ; alpha/beta
    lea (a1,d7.w),a1

    movea.l screentable,a6 ; store screentable in a6
    ; second word in the angular sequence is a global offset (in bytes, i.e. this can also be used to switch planes)
    adda.w (a5)+,a6

    lea palette,a2
    adda.w (a5)+,a2
    move.l a2,next_pal

    movea.l current_pos_in_off_seq,a5
    ; lea offset_seq,a5
    ; 64 values to offset each coordinate in y direction

    ; 1st line
    move.w 0(a1),d6 ; lower left x
    ; move.w 2(a1),d7 ; lower left y
    move.w 4(a1),d7 ; lower left z
    swap d7
    ; move.w 4(a1),a3 ; lower left z
    move.w 2(a1),d7 ; lower left y
    ; d7 contains now the y and the z coordinate (z in the upper word)

    move.w d6,d4 ; store for next line
    move.l d7,d5

    ; move.l screentable,a6 ; store screentable in a6
    ;; first word is a global offset (in bytes, i.e. this can also be used to switch planes)
    ;; adda.w (a5)+,a6
    move.l a6,a2 ; dot expects the screentable in a2 (but destroys it)
    move.w d6,d0
    move.w d7,d1
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1 ; y offset

    ; constant size
    ;bsr dot4x4

    swap d7
    bsr dot
    swap d7
    
    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0 ; xdiff x
    add.w 8(a1),d1 ; xdiff y
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1 ; y offset

    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7

    ;bsr dot4x4 ; dot3x3
    endr

    ; 2nd line
    add.w  18(a1),d4 ; zdiff x
    add.w  20(a1),d5 ; zdiff y
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7
    
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ;move.w d0,d6
    ;move.w d1,d7
    add.w (a5)+,d1
    
    ; draw the dot
    ; variant 1 constant size
    ;bsr dot4x4 ; dot3x3

    ; variant 2, size depending on z
    swap d7
    ; z is now in d7.w
    bsr dot
    swap d7 ; restore d7.w

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0 ; xdiff x
    add.w 8(a1),d1 ; xdiff y
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1

    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7

    ; bsr dot4x4 ; dot3x3
    endr

    ; 3rd line
    add.w  18(a1),d4
    add.w  20(a1),d5
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7

    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ; move.w d0,d6
    ; move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1

    swap d7
    bsr dot
    swap d7

    ;bsr dot4x4 ; dot3x3

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0
    add.w 8(a1),d1
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1

    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7

    ;bsr dot4x4 ; dot3x3
    endr

    ; 4th line
    add.w  18(a1),d4
    add.w  20(a1),d5
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7

    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ; move.w d0,d6
    ; move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    bsr dot
    swap d7
    ;bsr dot4x4 ; dot3x3

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0
    add.w 8(a1),d1
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1

    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7

    ; bsr dot4x4 ; dot3x3
    endr

    ; 5th line
    add.w  18(a1),d4
    add.w  20(a1),d5
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7

    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ; move.w d0,d6
    ; move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    bsr dot
    swap d7
    ;bsr dot4x4 ; dot3x3

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0
    add.w 8(a1),d1
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1

    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7

    ;bsr dot4x4 ; dot3x3
    endr

    ; 6th line
    add.w  18(a1),d4
    add.w  20(a1),d5
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7

    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ; move.w d0,d6
    ; move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    bsr dot
    swap d7
    ;bsr dot4x4 ; dot3x3

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0
    add.w 8(a1),d1
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7
    ; bsr dot4x4 ; dot3x3
    endr

    ; 7th line
    add.w  18(a1),d4
    add.w  20(a1),d5
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7

    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ; move.w d0,d6
    ; move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    bsr dot
    swap d7
    ;bsr dot4x4 ; dot3x3

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0
    add.w 8(a1),d1
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7
    ; bsr dot4x4 ; dot3x3
    endr

    ; 8th line
    add.w  18(a1),d4
    add.w  20(a1),d5
    swap d5
    add.w 22(a1),d5 ; zdiff z
    swap d5
    move.w d4,d6
    move.l d5,d7

    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    ; move.w d0,d6
    ; move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    bsr dot
    swap d7
    ;bsr dot4x4 ; dot3x3

    rept 7
    move.l a6,a2
    move.w d6,d0
    move.w d7,d1
    add.w 6(a1),d0
    add.w 8(a1),d1
    move.w d0,d6
    move.w d1,d7
    swap d6
    move.w (a5)+,d6 ; y offset
    add.w d6,d1
    swap d6
    ; add.w (a5)+,d1
    swap d7
    add.w 10(a1),d7
    bsr dot
    swap d7
    ; bsr dot4x4 ; dot3x3
    endr

    jsr swap_screen

    move.w curr_off_frame_cnt,d0
    addq #1,d0
    ; cmp.w (a5)+,d0

    cmp.w #5,d0 ; always 5 frames. period.

    blt.s endinter
    clr.w d0

    ; lea 128(a5),a5 ; next frame in sequence
    cmp.w #100,(a5)

    blt.s endinter_nextoffseq

    move.l current_off_playbook,a1
    addq.l #6,a1 ; skip ahead to the next sequence
    tst.w (a1)
    bge.s next_off_sequence ; there is a next sequence

    ; otherwise: start with the first sequence again
    lea off_playbook,a1
next_off_sequence:
    move.w (a1),curr_off_is_sliding
    move.l a1,current_off_playbook
    move.l 2(a1),a5

    ; lea drop_offset_seq,a5 ; start from first seq
    ; lea spectrum_offset_seq,a5 ; start from first seq

    tst     curr_off_is_sliding
    beq.s   no_sliding1
    lea     56*2(a5),a5
no_sliding1:

endinter_nextoffseq:
    tst.w   curr_off_is_sliding
    beq.s   no_sliding2
    lea     -56*2(a5),a5 ; skip only 8 ahead
no_sliding2:

    move.l a5,current_pos_in_off_seq
endinter:
    move.w d0,curr_off_frame_cnt

    move.l curr_pos_in_ang_seq,a5
    move.w curr_ang_frame_cnt,d0
    addq #6,a5
    addq #1,d0
    cmp.w (a5)+,d0
    blt.s endinter_ang
    clr.w d0
    tst.w (a5)
    bge.s endinter_nextangseq
    ; check where we are in the playbook, go to the next
    ; lea angular_seq,a5
    move.l current_ang_playbook,a1
    addq.l #6,a1 ; skip ahead to the next sequence
    tst.w (a1)
    bge.s next_ang_sequence ; there is a next sequence
    ; otherwise: start with the first sequence again
    lea ang_playbook,a1
next_ang_sequence:
    move.l a1,current_ang_playbook
    move.l 2(a1),a5

endinter_nextangseq:
    move.l a5,curr_pos_in_ang_seq
endinter_ang:
    move.w d0,curr_ang_frame_cnt

    ; move.l a6,a1 ; screentable in a1
    movea.l screentable,a1
    movea.l a1,a6
    lea 200*4*3(a1),a1 ; 4th plane
    jsr scroller

quitvbi:
    movem.l (sp)+,d0-d7/a0-a6
; either - branch to the old vector
    move.l  oldvbl,-(sp)        ; go to old vector (system friendly ;) )
    rts
; or: return from vbl routine (but then key stroke detection does not work)
    ; rte

; timer routines
newkey:
    move.w #$2500,sr ; tastaturinterrupt verhindern
newkey2:
    jmp $00000000

; timer b
newtb:
    clr.b $fffffa1b.w ; timer anhalten
    movem.l d0/d3-d7/a0-a6,-(sp)
    move.l dis,a0
    move.w #$fa21,a4
    move.b (a0)+,(a4)
    move.b #8,-6(a4)
    move.l a0,dis
    move.l pal,a6
    movem.l 2(a6),d4-d7/a0-a2
    move.w #$8240,a5
    move.w 30(a6),d3
    move.b (a4),d0
wait:
    cmp.b (a4),d0
    beq.s wait
    movem.l d4-d7/a0-a2,2(a5)
    move.w d3,30(a5)
    move.w (a6),(a5)
    add.l #32,pal
    movem.l (sp)+,d0/d3-d7/a0-a6
    bclr #0,$fffffa0f.w
    rte

; d7.w - 0-127 (z-value)
; d6 upper word: y offset
; destroys the upper word of d6 + anything that the dotXxX routines destroy
dot:
    lea dot_subroutines,a4 ; table for jumping to the dot routines
    swap d6
    add.w #90,d6
    btst #6,d6
    bne.s .dot_plane1
    lea 200*4(a2),a2
    btst #5,d6
    bne.s .dot_plane1
    lea 200*4(a2),a2
.dot_plane1:
    move.w d7,d6
    lsr.w #3,d6 ; /32, then *4
    and.w #$fffc,d6
    move.l (a4,d6.w),a4
    jsr (a4)
    swap d6
    rts

    data
sound_delay:
    dc.w 150 ; 3 secs
global_frame_cnt:
    dc.w 0
curr_off_is_sliding:
    dc.w 0
curr_off_frame_cnt:
    dc.w 0
current_pos_in_off_seq:
    dc.l silentseq50 ; TODO: this needs to be changed when the first entry in the playbook sequences changes
    ; dc.l spectrum_offset_seq

curr_ang_frame_cnt:
    dc.w 0
next_pal:
    dc.l palette
curr_pos_in_ang_seq:
    dc.l angular_seq0 ; TODO: this needs to be changed when the first entry in the playbook sequences changes
