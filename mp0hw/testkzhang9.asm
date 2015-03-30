ORIGIN 4x0000

SEGMENT  CodeSegment:

    LDR  R1, R0, FIVE    ; R1 <= 5
    LDR  R2, R0, ONE     ; R2 <= 1
    LDR  R4, R0, FIVE    ; R4 <= 5
    LDR  R5, R0, ONE     ;
    NOT  R5, R5          ;
    ADD  R5, R5, R2      ; R5 <= -1, 2's complement
    LDR  R2, R0, FIVE    ; R2 <= 5
    ADD  R1, R1, R5      ; R1 <= R1 -1
    ADD  R3, R1, R0      ; R3 <= R1
    ADD  R3, R3, R5      ; R3 <= R3 - 1
LOOP1:
    AND  R3, R3, R3      ;
    BRnz  MARK1          ; if R3 is not positive then jump out
    ADD  R2, R2, R4      ; R2 <= R2 + R4
    ADD  R3, R3, R5      ; R3 <= R3 - 1
    BRp  LOOP1
    ADD  R4, R2, R0      ; R4 <= R2
    ADD  R3, R1, R5      ; R3 <= R1 -1
    ADD  R3, R3, R5      ; R3 <= R3 - 1
    ADD  R1, R1, R5      ; R1 <= R1 -1
    BRp  LOOP1
MARK1:    
    STR R2, R0, RESULT
HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.
ONE:    DATA2 4x0001
FIVE:   DATA2 4x0005    ; change this number so it could easily calculate other factorials
RESULT: DATA2 4x0000
