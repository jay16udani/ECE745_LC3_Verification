interface dut_Probe_DE(	
                        // decode block interface signals
                        input   logic           [15:0]          decode_npc_in,
                        input   logic                           decode_enable_decode,
                        input   logic           [15:0]          decode_Instr_dout,
                        input   logic           [2:0]	        decode_PSR,
                        input   logic           [15:0]         	decode_IR,
                        input   logic           [5:0]           decode_E_control,
                        input   logic           [15:0]          decode_npc_out,
                        input   logic           	            decode_Mem_control,
						input   logic           [1:0]           decode_W_control,
						input	bit 							decode_reset,
						input   bit								decode_clk
						);
						
 	logic			goldenref_Mem_control;
 	logic	[15:0] 	goldenref_IR, goldenref_npc_out;
	logic 	[5:0]	goldenref_E_control;
	logic	[1:0]	goldenref_W_control;
	
	
	clocking cb_de @(posedge decode_clk);
		
		default input #1 output #0;

		// inputs to decode
		input   decode_enable_decode;
        input 	decode_IR
        
		// outputs from the decode
		output	goldenref_Mem_control;
		output 	goldenref_IR, goldenref_npc_out;
		output	goldenref_E_control;
		output	goldenref_W_control;
		
  	endclocking
	modport DECODE (clocking cb_de, input decode_reset,input decode_W_control,input decode_Mem_control,input decode_npc_out,input 	decode_npc_in,
	input decode_PSR, input decode_E_control, input   decode_Instr_dout);
endinterface

interface dut_Probe_Exec(
			
					// Execute Block design Interface
					input	logic  [5:0]	execute_E_control,
					input	logic  [15:0] 	execute_IR,
					input 	logic  [15:0] 	execute_npc_in,
					input	logic        	execute_bypass_alu_1,
					input	logic        	execute_bypass_alu_2,
					input	logic        	execute_bypass_mem_1,
					input	logic        	execute_bypass_mem_2,
					input	logic  [15:0] 	execute_VSR1,
					input	logic  [15:0] 	execute_VSR2,
					input	logic  [1:0]  	execute_W_Control_in,
					input	logic        	execute_Mem_Control_in,
					input	logic        	execute_enable_execute,
					input	logic  [15:0] 	execute_Mem_Bypass_Val,
					input	logic  [1:0]  	execute_W_Control_out,
					input	logic        	execute_Mem_Control_out,
					input	logic  [15:0] 	execute_aluout,
					input	logic  [15:0] 	execute_pcout,
					input	logic  [2:0]  	execute_dr,
					input	logic  [2:0]  	execute_sr1,
					input	logic  [2:0]  	execute_sr2,
					input	logic  [15:0] 	execute_IR_Exec,
					input	logic  [2:0]  	execute_NZP,
					input	logic  [15:0] 	execute_M_Data,
					input	bit 			execute_reset,
					input   bit				execute_clk
				
					);

	logic [1:0] goldenref_W_Control_out;
	logic goldenref_Mem_Control_out;
	logic [15:0] goldenref_aluout;
	logic [15:0] goldenref_pcout;
	logic [2:0] goldenref_dr;
	logic [2:0] goldenref_sr1;
	logic [2:0] goldenref_sr2;
	logic [15:0] goldenref_IR_Exec;
	logic [2:0] goldenref_NZP;
	logic [15:0] goldenref_M_Data;
	
	clocking cb_Exe @(posedge execute_clk);
		
		default input #1 output #0;

		// inputs to execute
		input	execute_E_control;
		input	execute_bypass_alu_1;
		input	execute_bypass_alu_2;
		input	execute_bypass_mem_1;
		input	execute_bypass_mem_2;
		
		// outputs from the Writeback
		output goldenref_W_Control_out;
		output goldenref_Mem_Control_out;
		output goldenref_aluout;
		output goldenref_pcout;
		output goldenref_dr;
		output goldenref_IR_Exec;
		output goldenref_NZP;
		output goldenref_M_Data;
		
  	endclocking

modport EXECUTE (clocking cb_Exe, input execute_reset, output goldenref_sr1, output goldenref_sr2, input execute_IR, input	execute_VSR1, 
		input	execute_VSR2, input execute_W_Control_in, input	execute_Mem_Control_in, input execute_enable_execute, input	execute_Mem_Bypass_Val,
		input	execute_W_Control_out,input	execute_Mem_Control_out,input	execute_aluout,input	execute_pcout,input	execute_dr,input execute_sr1,
		input	execute_sr2,input execute_IR_Exec,input	execute_NZP,input execute_M_Data,input execute_npc_in);
endinterface





