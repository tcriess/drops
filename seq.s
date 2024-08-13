; sequences
    data
angular_seq0:
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 150 ; frames
    dc.w -1

angular_seq0_flash:
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 4*6 ; global offset
    dc.w 32 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 4*12 ; global offset
    dc.w 32 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 4*18 ; global offset
    dc.w 32 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 4*12 ; global offset
    dc.w 32 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 4*6 ; global offset
    dc.w 32 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w -6*4 ; global offset
    dc.w 64 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w -12*4 ; global offset
    dc.w 64 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w -18*4 ; global offset
    dc.w 64 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w -12*4 ; global offset
    dc.w 64 ; palette offset
    dc.w 1 ; frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w -6*4 ; global offset
    dc.w 64 ; palette offset
    dc.w 1 ; frames
    dc.w -1

angular_slow_rot1: ; length: 95 frames
    dc.w 1*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5 ; frames
    dc.w 1*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+7*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+8*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+9*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+8*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+7*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+3*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+2*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+1*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+0*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+1*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+2*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+3*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w -1

angular_slow_rot2: ; length: 95 frames
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5 ; frames
    dc.w 3*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 2*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+7*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 0*bytes_per_alpha+8*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+9*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 2*bytes_per_alpha+8*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 3*bytes_per_alpha+7*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 2*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 0*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+3*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 2*bytes_per_alpha+2*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 3*bytes_per_alpha+1*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 2*bytes_per_alpha+0*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+1*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 0*bytes_per_alpha+2*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+3*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    dc.w 1*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 0 ; palette offset
    dc.w 5
    
    ; more sequences here
    dc.w -1

drop_offset_seq:
    include "gen_drop_offsets.s"

spectrum_offset_seq:
    include "gen_spectrum_offsets.s"
