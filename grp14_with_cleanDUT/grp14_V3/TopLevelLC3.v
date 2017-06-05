`include "data_defs.vp"
module LC3 (	clock, reset, pc, instrmem_rd, Instr_dout, Data_addr, complete_instr, complete_data,  
				Data_din, Data_dout, Data_rd			
			);
	input			clock, reset;
	input			complete_instr, complete_data;
	output	[15:0] 	pc, Data_addr;
	output			instrmem_rd, Data_rd; 
	input	[15:0]	Instr_dout, Data_dout;
	output	[15:0]	Data_din;
	
	wire			enable_updatePC, br_taken,  enable_decode, enable_execute, enable_writeback, enable_fetch;
	wire	[15:0]	npc_out_fetch, taddr, IR, IR_Exec, npc_out_dec; 
	wire	[5:0] 	E_Control;
	wire 	[1:0] 	W_Control;													
	wire 			Mem_Control;													


	wire			bypass_alu_1, bypass_alu_2;	
	wire			bypass_mem_1, bypass_mem_2;
	wire	[15:0]	VSR1, VSR2, aluout, pcout;
	wire	[2:0] 	psr;
   	wire	[1:0] 	W_Control_out;
   	wire			Mem_Control_out;
   	
   	wire	[2:0]	sr1, sr2, dr, NZP;
   	
   	wire	[1:0]	mem_state;
   	wire			M_Control;
   	wire	[15:0]	M_Data, memout;
   	
   
	Fetch	Fetch (
					.clock(clock), .reset(reset), .enable_updatePC(enable_updatePC), 
					.enable_fetch(enable_fetch), .pc(pc), .npc_out(npc_out_fetch), 
					.instrmem_rd(instrmem_rd), .taddr(pcout), .br_taken(br_taken)
				);

	Decode  Dec (
					.clock(clock), .reset(reset), .enable_decode(enable_decode), 
					.dout(Instr_dout), .E_Control(E_Control), //.F_Control(F_Control), 
					.npc_in(npc_out_fetch), //.psr(psr), 
					.Mem_Control(Mem_Control), .W_Control(W_Control), 
					.IR(IR), .npc_out(npc_out_dec)
	      		);							
	Execute	Ex	(		
					.clock(clock), .reset(reset), .E_Control(E_Control), .bypass_alu_1(bypass_alu_1), 
					.bypass_alu_2(bypass_alu_2), .IR(IR), .npc(npc_out_dec), .W_Control_in(W_Control), 
					.Mem_Control_in(Mem_Control), .VSR1(VSR1), .VSR2(VSR2), 
					.bypass_mem_1(bypass_mem_1), .bypass_mem_2(bypass_mem_2), .Mem_Bypass_Val(memout),
					.enable_execute(enable_execute), .W_Control_out(W_Control_out), 
					.Mem_Control_out(Mem_Control_out), .aluout(aluout), .pcout(pcout), 
					.sr1(sr1), .sr2(sr2), .dr(dr), .M_Data(M_Data), .NZP(NZP), .IR_Exec(IR_Exec)
				); 

	MemAccess	MemAccess (	
					.mem_state(mem_state), .M_Control(Mem_Control_out), .M_Data(M_Data), .M_Addr(pcout), 
					.memout(memout), .Data_addr(Data_addr), .Data_din(Data_din), .Data_dout(Data_dout), 
					.Data_rd(Data_rd)
				);

	Writeback	WB 		(	
					.clock(clock), .reset(reset), .enable_writeback(enable_writeback), 
					.W_Control(W_Control_out), .aluout(aluout), .memout(memout), .pcout(pcout), 
					.npc(npc_out_dec), .sr1(sr1), .sr2(sr2), .dr(dr), .d1(VSR1), .d2(VSR2), .psr(psr)
				);
				
	Controller_Pipeline Ctrl (
					.clock(clock), .reset(reset), .IR(IR), .complete_data(complete_data), .complete_instr(complete_instr), 
					.bypass_alu_1(bypass_alu_1), .bypass_alu_2(bypass_alu_2),
					.bypass_mem_1(bypass_mem_1), .bypass_mem_2(bypass_mem_2), 
					.enable_fetch(enable_fetch), .enable_decode(enable_decode), 
					.enable_execute(enable_execute), .enable_writeback(enable_writeback), 
					.enable_updatePC(enable_updatePC), .mem_state(mem_state),
					.NZP(NZP), .psr(psr), .IR_Exec(IR_Exec), .Instr_dout(Instr_dout), .br_taken(br_taken)
				);
								
endmodule
