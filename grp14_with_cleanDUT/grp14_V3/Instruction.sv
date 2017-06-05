`ifndef GAURD_INSTRUCTION
`define GAURD_INSTRUCTION

`include "params.sv"

class Instruction;
	rand bit [15:0] Instr_base;
	rand instr_type_e Instr_type;
	rand instr_opcode_e Instr_opcode;

	constraint c_PrevIsMEM {
		Instr_type dist {ALU:=1, CTRL:=1, MEM:=0};
	}
	
	constraint c_PrevIsCTRL {
		Instr_type dist {ALU:=1, MEM:=3, CTRL:=0};
	}
	
	constraint c_ALU {
		Instr_type inside {ALU};
	}
	
	constraint c1 {
		solve Instr_type before Instr_opcode;
		Instr_type == ALU -> Instr_opcode inside {ADD,AND,NOT,LEA};
		Instr_type == MEM -> Instr_opcode dist {LD:=1,LDR:=7,LDI:=1,ST:=1,STR:=7,STI:=1};
		Instr_type == CTRL -> Instr_opcode inside {BR,JMP};
	}

	constraint c2 {
		Instr_opcode == ADD -> Instr_base[5:0] inside {[0:7],[32:63]};
		Instr_opcode == AND -> Instr_base[5:0] inside {[0:7],[32:63]};
		Instr_opcode == NOT -> Instr_base[5:0] == 6'b111111;
		Instr_opcode == BR  -> Instr_base[11:9] inside {[1:7]};
		Instr_opcode == JMP -> Instr_base[11:9] == 3'b111;
		Instr_opcode == JMP -> Instr_base[5:0] == 6'b0;
		Instr_opcode == LDR -> Instr_base[8:6] dist {0:=2,1:=3,2:=3,3:=2,4:=3,5:=3,6:=2,7:=2};
		Instr_opcode == STR -> Instr_base[8:6] dist {0:=3,1:=2,2:=3,3:=2,4:=2,5:=3,6:=2,7:=3};
		Instr_base[15:12] == Instr_opcode;
	}
endclass
`endif
