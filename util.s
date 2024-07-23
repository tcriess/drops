; misc utility functions

; scan keys
scan_keys:
; see if a key has been pressed; don't wait (BIOS call BCONSTAT).
; returns -1 in d0 if a key was pressed
    move.w  #2,-(sp)        ; look at the keyboard
    move.w  #1,-(sp)        ; was a key pressed?
    trap    #13             ; bios call
    addq.l  #4,sp           ; tidy stack
    rts
