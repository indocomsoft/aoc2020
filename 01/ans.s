.cpu cortex-a7
.global main
.type main, %function
main:
STMFD SP!, {R4, LR}
BL Helper_0
MOV R4, R0
MOV R1, R4
BL Helper_1
MOV R1, R4
BL Helper_3
MOV R0, #0
LDMFD SP!, {R4, PC}
.global Helper_0
.type Helper_0, %function
Helper_0:
STMFD SP!, {R3, R4, R5, LR}
MOV R5, #0
MOV R0, #1
MOV R1, #12
BL calloc
MOV R4, R0
BL LL_0
L1:
CMP R5, #200
BGE L2
BL readln_int
MOV R1, R0
MOV R0, R4
BL LL_1
ADD R5, R5, #1
B L1
L2:
MOV R0, R4
LDMFD SP!, {R3, R4, R5, PC}
.global Helper_1
.type Helper_1, %function
Helper_1:
STMFD SP!, {R3, R4, R5, LR}
MOV R4, R1
LDR R5, [R4, #4]
L3:
MOV R1, R5
MOV R2, R4
BL Helper_2
CMP R0, #0
BEQ L7
LDMFD SP!, {R3, R4, R5, PC}
L7:
LDR R1, [R5, #8]
CMP R1, #0
BEQ L5
LDR R5, [R5, #4]
B L3
L5:
LDMFD SP!, {R3, R4, R5, PC}
.global Helper_2
.type Helper_2, %function
Helper_2:
STMFD SP!, {R3, R4, R5, LR}
LDR R5, [R2, #4]
L9:
LDR R0, [R1]
LDR R4, [R5]
ADD R4, R0, R4
LDR R0, =#2020
CMP R4, R0
BNE L13
LDR R4, [R1]
LDR R0, [R5]
CMP R4, R0
BEQ L13
LDR R0, [R1]
LDR R1, [R5]
MUL R1, R0, R1
LDR R0, .S0
BL printf
MOV R0, #1
LDMFD SP!, {R3, R4, R5, PC}
L13:
LDR R0, [R5, #8]
CMP R0, #0
BEQ L11
LDR R5, [R5, #4]
B L9
L11:
MOV R0, #0
LDMFD SP!, {R3, R4, R5, PC}
.global Helper_3
.type Helper_3, %function
Helper_3:
STMFD SP!, {R3, R4, R5, LR}
MOV R4, R1
LDR R5, [R4, #4]
L15:
MOV R1, R5
MOV R2, R4
BL Helper_4
CMP R0, #0
BEQ L19
LDMFD SP!, {R3, R4, R5, PC}
L19:
LDR R1, [R5, #8]
CMP R1, #0
BEQ L17
LDR R5, [R5, #4]
B L15
L17:
LDMFD SP!, {R3, R4, R5, PC}
.global Helper_4
.type Helper_4, %function
Helper_4:
STMFD SP!, {R4, R5, R6, LR}
MOV R5, R1
MOV R4, R2
LDR R6, [R4, #4]
L21:
LDR R1, [R5]
LDR R2, [R6]
CMP R1, R2
BEQ L25
MOV R1, R5
MOV R2, R6
MOV R3, R4
BL Helper_5
CMP R0, #0
BEQ L25
MOV R0, #1
LDMFD SP!, {R4, R5, R6, PC}
L25:
LDR R1, [R6, #8]
CMP R1, #0
BEQ L23
LDR R6, [R6, #4]
B L21
L23:
MOV R0, #0
LDMFD SP!, {R4, R5, R6, PC}
.global Helper_5
.type Helper_5, %function
Helper_5:
STMFD SP!, {R4, R5, R6, R7, R8, LR}
LDR R4, [R3, #4]
L27:
LDR R5, [R1]
LDR R7, [R2]
LDR R6, [R4]
CMP R5, R6
BEQ L31
CMP R7, R6
BEQ L31
ADD R0, R5, R7
ADD R8, R0, R6
LDR R0, =#2020
CMP R8, R0
BNE L31
MUL R0, R5, R7
MUL R1, R0, R6
LDR R0, .S0
BL printf
MOV R0, #1
LDMFD SP!, {R4, R5, R6, R7, R8, PC}
L31:
LDR R0, [R4, #8]
CMP R0, #0
BEQ L29
LDR R4, [R4, #4]
B L27
L29:
MOV R0, #0
LDMFD SP!, {R4, R5, R6, R7, R8, PC}
.global LL_0
.type LL_0, %function
LL_0:
MOV R1, #1
STR R1, [R0]
MOV R1, #0
STR R1, [R0, #4]
MOV R1, #0
STR R1, [R0, #8]
BX LR
.global LL_1
.type LL_1, %function
LL_1:
STMFD SP!, {R3, R4, R5, LR}
MOV R4, R0
MOV R5, R1
MOV R0, #1
MOV R1, #12
BL calloc
MOV R1, R0
STR R5, [R1]
MOV R2, #0
STR R2, [R1, #4]
MOV R2, #0
STR R2, [R1, #8]
LDR R2, [R4]
CMP R2, #0
BEQ L33
STR R1, [R4, #4]
STR R1, [R4, #8]
MOV R1, #0
STR R1, [R4]
LDMFD SP!, {R3, R4, R5, PC}
L33:
LDR R3, [R4, #8]
MOV R2, #1
STR R2, [R3, #8]
LDR R2, [R4, #8]
STR R1, [R2, #4]
STR R1, [R4, #8]
LDMFD SP!, {R3, R4, R5, PC}
.global readln_int
.type readln_int, %function
readln_int:
STMFD SP!, {R4, LR}
SUB SP, SP, #16
MOV R0, #0
STR R0, [SP, #8]
STR R0, [SP, #4]
LDR R0, .Lstdin
LDR R2, [R0]
ADD R0, SP, #8
ADD R1, SP, #4
BL getline
LDR R0, [SP, #8]
LDR R1, .S1
ADD R2, SP, #12
BL sscanf
LDR R0, [SP, #8]
BL free
LDR R0, [SP, #12]
ADD SP, SP, #16
LDMFD SP!, {R4, PC}
.Lstdin:
.word stdin
.S0:
.word .S0S
.S1:
.word .S1S
.section .rodata
.S0S:
.asciz "%d\n"
.section .rodata
.S1S:
.asciz "%d"
