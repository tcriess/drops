; the "playbook" of which sequences to play in order
    data
current_off_playbook:
    dc.l off_playbook ; address of the current playbook position

off_playbook:
    dc.w 0
    dc.l silentseq50
    dc.w 0
    dc.l silentseq50
    dc.w 0
    dc.l silentseq50
    dc.w 0 ; 0 or 1, 0 is normal, 1 is sliding window
    dc.l dropseq48 ; address of the offset sequence
    dc.w 0
    dc.l dropseq64
    dc.w 0
    dc.l dropseq32
    dc.w 1
    dc.l spectrum_offset_seq
    dc.w -1

current_ang_playbook:
    dc.l ang_playbook

ang_playbook:
    dc.w 0
    dc.l angular_seq0 ; 150 frames
    dc.w 0 ; filler
    dc.l angular_seq0_flash ; 10 frames
    dc.w 0 ; filler
    dc.l angular_slow_rot1 ; 95
    dc.w 0 ; filler
    dc.l angular_slow_rot2 ; 95
    dc.w 0 ; filler
    dc.l angular_slow_rot1 ; 95
    dc.w -1