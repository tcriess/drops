; bss section at the end of the program
    bss
screen:     ds.l 1 ; current screen address
pscreen:    ds.l 1 ; physical screen address
lscreen:    ds.l 1 ; logical screen address
screentable:    ds.l 1 ; address pointing to screentable1 or screentable2
screentable1:   ds.l 200 ; 160-bytes-steps of screen address (1)
screentable2:   ds.l 200 ; 160-bytes-steps of screen address (2)
textab:  DS.L 8000                               ;ABSOLUTE ADDRESSES FOR TEXT STRIPS
ypos:    DS.L 40                                 ;SCREEN ADDRESSES TO PUT TEXT
sv_ssp:     ds.l 1 ; saved user stack pointer
saveres:    ds.w 1 ; saved screen resolution
savehz:     ds.b 1 ; saved screen frequency (only bit 1(?))
    even
stdpalette: ds.w 16 ; default palette
oldvbl:     ds.l 1
    ; stack, 500 l = 1000 w = 2000 bytes
    ds.l 500
stack:
    ds.l 1
