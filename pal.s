    data
palette:
    DC.w $0000,$0700,$0072,$0075,$407,$0470,$7,$7 ; 0
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$507,$0470,$7,$7 ; 1
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$607,$0470,$7,$7 ; 2
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$707,$0470,$7,$7 ; 3
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0300,$0072,$0075,$717,$0470,$7,$7 ; 4
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$727,$0470,$7,$7 ; 5
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$737,$0470,$7,$7 ; 6
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$747,$0470,$7,$7 ; 7
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777
    DC.w $0000,$0700,$0072,$0075,$757,$0470,$7,$7 ; 8
    DC.w $7,$7,$7,$0007,$0007,$0007,$7,$7777

palstart:
    dc.l palette
disstart:
    dc.l distanz
contr:
    dc.b 21,4,15,6
pal:
    dc.l 0
dis:
    dc.l 0
distanz:
    ; dc.b 131,4,4,4,4,4,4,4,240
    dc.b 131,8,8,8,8,8,8,8,240-28
;    dc.b 19,20,20,20,20,20,20,20,240
    even