; the "playbook" of which sequences to play in order
    data
current_off_playbook:
    dc.l off_playbook ; address of the current playbook position

off_playbook:
    dc.w 0 ; 0 or 1, 0 is normal, 1 is sliding window
    dc.l drop_offset_seq ; address of the offset sequence
    dc.w 1
    dc.l spectrum_offset_seq
    dc.w -1

current_ang_playbook:
    dc.l ang_playbook

ang_playbook:
    dc.w 0 ; filler
    dc.l angular_seq
    dc.w -1