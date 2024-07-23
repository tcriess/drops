; vertical blank interrupt routine
; vbl:    
;    bsr     music+8                 ; call music
; either - branch to the old vector
;    move.l  oldvbl,-(sp)        ; go to old vector (system friendly ;) )
;    rts
; or: return from vbl routine (but then key stroke detection does not work)
;    ; rte