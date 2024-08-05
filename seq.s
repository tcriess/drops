; sequences
    data
angular_seq:
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 200*4 ; global offset
    dc.w 5 ; frames
    dc.w 2*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 200*4 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 12 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 8 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 4 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+3*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+2*bytes_per_diff ; alpha/beta offset
    dc.w -4 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+1*bytes_per_diff ; alpha/beta offset
    dc.w -8 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+0*bytes_per_diff ; alpha/beta offset
    dc.w -4 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+1*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+2*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+3*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+4*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+5*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+7*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+8*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+9*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+10*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+11*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+12*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+13*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+14*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+15*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+16*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+17*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+18*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+19*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+20*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+21*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+20*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+18*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+16*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+14*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+12*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+10*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+8*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5
    dc.w 2*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5

    dc.w 3*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 15
    dc.w 4*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 15
    dc.w 5*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 15
    dc.w 4*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 10
    dc.w 3*bytes_per_alpha+6*bytes_per_diff ; alpha/beta offset
    dc.w 0 ; global offset
    dc.w 5

    ; more sequences here
    dc.w -1

drop_offset_seq:
    include "gen_drop_offsets.s"

spectrum_offset_seq:
    include "gen_spectrum_offsets.s"
