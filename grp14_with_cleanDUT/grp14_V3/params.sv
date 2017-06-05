typedef enum logic [3:0] { 
		ADD = 4'b0001,
                AND = 4'b0101,
                NOT = 4'b1001,
                LD = 4'b0010,
                LDR = 4'b0110,
                LDI = 4'b1010,
                LEA = 4'b1110,
                ST = 4'b0011,
                STR = 4'b0111,
                STI = 4'b1011,
                BR = 4'b0000,
                JMP = 4'b1100 } instr_opcode_e;

typedef enum logic [1:0] {
		ALU = 2'b00,
		MEM = 2'b01,
		CTRL = 2'b10 } instr_type_e;


