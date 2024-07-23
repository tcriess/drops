; bss section at the end of the program
    bss
pscreen:    ds.l 1 ; physical screen address
lscreen:    ds.l 1 ; logical screen address
screentable:    ds.l 200 ; 160-bytes-steps of screen address
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
