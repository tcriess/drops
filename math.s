; some mathematical utility functions
; square root of d0.w (shifted by 3 bits?)

; the bit shift that is used for the registers that hold fractional numbers
; f.e. "3" means that the value in d1 holds the fractional part in the
; lower 3 bits and the integer part in the remaining bits, i.e. the value
; has to be shifted by 3 to get only the integer part.
bitshift equ 3

; square root of d (in d0)
; returns square root in d1
; destroys d1,d2,d3,d4 and d7
    text
sqrt:
; d1: x_k, x_0 = ~sqrt(d) (init value close to the target)
; d2: v_k, v_0 = ~1/x_0
; we use d/2 as the start value x_0
    move.w  d0,d1
    lsr.w   #1,d1
; and x0/2 as the start value v_0
    move.w  d1,d2
    lsr.w   #1,d2

    move.w #10,d7 ; 10 iterations
v_next: ; v_{k+1} = v_k + v_k * (1 - x_k * v_k)
    move.w d2,d3
    muls.w d1,d3 ; d3 = x_k * v_k
    moveq #1,d4
    sub.w d3,d4  ; d4 = 1 - x_k * v_k)
    muls.w d2,d4 ; d4 = v_k * (1-xk * v_k)
    add.w d4,d2 ; d2 = v_k + v_k * (1 - x_k * v_k) = v_{k+1}
    
x_next: ; x_{k+1} = x_k - v_{k+1} * (x_k * x_k - d) * 0.5
    move.w d1,d3 ; d3 = x_k
    muls.w d3,d3 ; d3 = x_k * x_k
    sub.w d0,d3  ; d3 = x_k * x_k - d
    muls.w d2,d3 ; d3 = v_{k+1} * (x_k * x_k - d)
    lsr.w #1,d3  ; d3 = 0.5 * v_{k+1} * (x_k * x_k - d)
    add.w d3,d1  ; d1 = x_{k+1}

    dbra d7,v_next
    rts