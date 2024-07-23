; precomputed coordinates / coordinate differences for different angles

; 3 diffs per angle combination = 6 bytes
; 36 angle combinations -> 36 * 6 = 216 bytes
; 2 different step directions (x and y differences) -> 432 bytes total
; (not yet: all values are shifted to the left by 4 bits (*16))

coord_diffs:
    include "diffs.s"

coord_diffs_end: