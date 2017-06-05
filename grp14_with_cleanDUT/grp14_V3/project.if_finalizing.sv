interface LC3_io(input bit clock);
  	
	logic reset, instrmem_rd, complete_instr, complete_data, Data_rd; 
	logic [15:0] pc, Instr_dout, Data_addr,  Data_dout, Data_din;
  	

  	clocking cb @(posedge clock);
 	default input #1 output #0;

		// instruction memory side
		input	pc; 
   		input	instrmem_rd;  
   		output Instr_dout;

		// data memory side
		input Data_din;
		input Data_rd;
		input Data_addr;		
		output Data_dout;
		
		output reset;
		
  	endclocking

  	modport TB(clocking cb, output complete_data, output complete_instr);   //modify to include reset
endinterface




interface dut_Probe_if(	
                        // fetch block interface signals
                        input   logic fetch_enable_updatePC,
                        input   logic fetch_enable_fetch,
                        input   logic fetch_br_taken,
                        input   logic [15:0] fetch_taddr,
                        input   logic fetch_instrmem_rd,
                        input   logic [15:0] fetch_pc,
                        input   logic [15:0] fetch_npc,
                        input	bit fetch_reset,
			input   bit clock
						);

 	logic	goldenref_instrmem_rd;
 	logic	[15:0]	goldenref_pc, goldenref_npc;

  	clocking cb @(posedge clock);
	//clocking cb @(posedge fetch_clk);
		default input #1 output #0;

		// inputs to Fetch
		input fetch_enable_updatePC;
		input fetch_br_taken;
		input fetch_instrmem_rd;

		// outputs from the fetch
		output goldenref_pc;
		output goldenref_npc;
  	endclocking	
	
	modport FETCH (clocking cb, input fetch_reset,output goldenref_instrmem_rd, input fetch_enable_fetch,input fetch_taddr, input fetch_pc, input fetch_npc);
endinterface

interface dut_Probe_DE(	
                        // decode block interface signals
                        input   logic           [15:0]          decode_npc_in,
                        input   logic                           decode_enable_decode,
                        input   logic           [15:0]          decode_Instr_dout,
                       // input   logic           [2:0]	        decode_PSR,
                        input   logic           [15:0]         	decode_IR,
                        input   logic           [5:0]           decode_E_control,
                        input   logic           [15:0]          decode_npc_out,
                        input   logic           	        decode_Mem_control,
			input   logic           [1:0]           decode_W_control,
			input	bit 				decode_reset,
			input   bit				decode_clk
						);
						
 	logic		goldenref_Mem_Control;
 	logic	[15:0] 	goldenref_IR, goldenref_npc_out;
	logic 	[5:0]	goldenref_E_control;
	logic	[1:0]	goldenref_W_Control;
	
	
	clocking cb @(posedge decode_clk);
		
		default input #1 output #0;

		// inputs to decode 
		input   decode_enable_decode;
       		//input 	decode_IR;
		input decode_npc_in;
		input decode_Instr_dout;
        
		// outputs from the decode

		output	goldenref_IR;
		output	goldenref_npc_out;
		output	goldenref_E_control;
		output	goldenref_W_Control;
		
  	endclocking
	modport DECODE (clocking cb, input decode_reset,input decode_W_control,input decode_Mem_control,input decode_npc_out,input decode_E_control, 
	 output	goldenref_Mem_Control,input decode_IR);
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
					input	bit 		execute_reset,
					input   bit		execute_clk
				
					);

	logic [15:0] internal_execute_alu1;
	logic [15:0] internal_execute_alu2;
	logic [1:0] goldenref_W_Control_out;
	logic 		goldenref_Mem_Control_out;
	logic [15:0] goldenref_aluout;
	logic [15:0] goldenref_pcout;
	logic [2:0] goldenref_dr;
	logic [2:0] goldenref_sr1;
	logic [2:0] goldenref_sr2;
	logic [15:0] goldenref_IR_Exec;
	logic [2:0] goldenref_NZP;
	logic [15:0] goldenref_M_Data;

endinterface


interface dut_Probe_WB(
			
					// Mem Block design Interface
					input	logic  [15:0]	writeback_npc,
                    input	logic  [1:0]  	writeback_W_control_in,
                    input	logic  [15:0] 	writeback_aluout,
                    input	logic  [15:0] 	writeback_pcout,
                    input	logic  [15:0] 	writeback_memout,
                    input	logic        	writeback_enable_writeback,
                    input	logic  [2:0]  	writeback_sr1,
                    input	logic  [2:0]  	writeback_sr2,
                    input	logic  [2:0]  	writeback_dr,
                    input	logic  [15:0] 	writeback_VSR1,
                    input	logic  [15:0] 	writeback_VSR2,
                    input	logic  [2:0]  	writeback_psr,
					input	bit 			writeback_reset,
					input   bit				writeback_clk
					);
					
	logic  [15:0] 	goldenref_writeback_VSR1;
    logic  [15:0] 	goldenref_writeback_VSR2;
    logic  [2:0]  	goldenref_writeback_psr;
	
	clocking cb_writeback @(posedge writeback_clk);
		
		default input #1 output #0;

		// inputs to writeback
		input	writeback_npc;
       	 	input	writeback_W_control_in;
        	input	writeback_aluout;
        	input	writeback_pcout;
        	input	writeback_memout;
        	input	writeback_enable_writeback;
        	input	writeback_dr;

		// outputs from the Writeback

		//output	goldenref_writeback_psr;
		
  	endclocking
	
	modport WB (clocking cb_writeback,output goldenref_writeback_VSR1,output goldenref_writeback_VSR2,input writeback_reset,input writeback_sr1,input writeback_sr2,input writeback_psr,input writeback_VSR1,input writeback_VSR2,input writeback_clk,output goldenref_writeback_psr);
endinterface


interface memAccess_if(
					//Required o/p signals of DUT's Execute for driving GoldRef's MemAccess 
					input logic   [15:0] M_Data,
					input logic   [15:0] M_addr,
					input logic   [15:0] memout,
					input logic 	     M_Control,
					//Required o/p signals of DUT's Controller for driving GoldRef's MemAccess 
					input logic   [1:0]  mem_state,
					//Required o/p signals of DUT's MemAccess for checking GoldRef's MemAccess o/p's 
					input logic   [15:0] Data_addr,Data_din,Data_dout,
					input logic          Data_rd,
					input bit 	     clock
			);
			logic [15:0] GoldRef_Data_addr, GoldRef_Data_din, GoldRef_Data_dout;
		        logic GoldRef_Data_rd;
			//No clocking block is required as stage is completely
			//async
endinterface


interface dut_Probe_CON(	
                        // control block interface signals
                        input   logic      			control_complete_data,    
                        input   logic      			control_complete_instr,
                        input   logic      [15:0]	control_IR,
                        input   logic      [2:0]     control_PSR,
                        input   logic      [15:0]     control_IR_Exec,
                        input   logic      [15:0]     control_IMem_dout,
                        input   logic      [2:0]     control_NZP,
                        input   logic           control_enable_updatePC,
						input   logic           control_enable_fetch,
						input   logic           control_enable_decode,
						input   logic           control_enable_execute,
						input   logic           control_enable_writeback,
						input   logic           control_bypass_alu_1,
						input   logic           control_bypass_alu_2,
						input   logic           control_bypass_mem_1,
						input   logic           control_bypass_mem_2,
						input   logic      [1:0]     control_mem_state,
						input   logic           control_br_taken,
						input	bit 			control_reset,
						input   bit				control_clk
						);
						
 	logic           mycontrol_enable_updatePC;
	logic           mycontrol_enable_fetch;
	logic           mycontrol_enable_decode;
	logic           mycontrol_enable_execute;
	logic           mycontrol_enable_writeback;
	logic           mycontrol_bypass_alu_1;
	logic           mycontrol_bypass_alu_2;
	logic           mycontrol_bypass_mem_1;
	logic           mycontrol_bypass_mem_2;
	logic [1:0]     mycontrol_mem_state;
	logic           mycontrol_br_taken;
	
endinterface

/*//Assertions for behavioural modeling
	property reset;
		@(posedge clock)
			(top_io.reset==1'b1) |-> (dut_if.pc==16'h3000 && 
									dut_de.IR==0 && 
									dut_de.npc_out==0 && 
									dut_de.E_Control==0 && 
									dut_de.W_Control==0 && 
									dut_de.Mem_Control==0 && 
									dut_exec.W_Control_out==0 && 
									dut_exec.Mem_Control_out==0 && 
									dut_exec.aluout==0 && 
									dut_exec.pcout==0 && 
									dut_exec.IR_Exec==0 && 
									dut_exec.NZP==0 && 
									dut_exec.M_Data==0 && 
									dut_exec.dr==0 && 
									dut_wb.psr==0);
	endproperty					
	top_reset :cover property (reset);
	
	
	property br_taken;
		@(posedge top_io.clock)
			|(dut_exec.NZP)==1 |=> (dut_Con.br_taken ==1);
	endproperty
	CTRL_br_taken_jmp : cover property (br_taken);
	
	
	//enable decode low for LD/LDR/ST/STR
	property enable_decode1;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LD || 
			dut_Con.IR_Exec[15:12]==LDR || 
			dut_Con.IR_Exec[15:12]==ST || 
			dut_Con.IR_Exec[15:12]==STR) 		
			|->
			dut_Con.enable_decode==1'b0;
	endproperty
	CTRL_enable_decode1 : cover property (enable_decode1);

	
	//enable decode high for LD/LDR/ST/STR
	property enable_decode2;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LD ||
			dut_Con.IR_Exec[15:12]==LDR ||
			dut_Con.IR_Exec[15:12]==ST ||
			dut_Con.IR_Exec[15:12]==STR) 		
			|=> 
			dut_Con.enable_decode==1'b1;
	endproperty
	CTRL_enable_decode2 : cover property (enable_decode2);

	
	//enable decode low for LDI/STI
	property enable_decode3;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LDI ||
			dut_Con.IR_Exec[15:12]==STI) 		
			|-> 
			dut_Con.enable_decode==1'b0;
	endproperty
	CTRL_enable_decode3 : cover property (enable_decode3);

	
	//enable decode high for LDI/STI
	property enable_decode4;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LDI ||
			dut_Con.IR_Exec[15:12]==STI)		 
			##2
			dut_Con.enable_decode==1'b1;
	endproperty
	CTRL_enable_decode4 : cover property (enable_decode4);

	
	//enable fetch low for LD/LDR/ST/STR
	property enable_fetch1;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LD || 
			dut_Con.IR_Exec[15:12]==LDR || 
			dut_Con.IR_Exec[15:12]==ST || 
			dut_Con.IR_Exec[15:12]==STR) 
			|-> 
			dut_Con.enable_fetch==1'b0;       
	endproperty
	CTRL_enable_fetch1 : cover property (enable_fetch1);

	
	//enable fetch high for LD/LDR/ST/STR
	property enable_fetch2;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LD ||
			dut_Con.IR_Exec[15:12]==LDR ||
			dut_Con.IR_Exec[15:12]==ST ||
			dut_Con.IR_Exec[15:12]==STR) 
			|=> 
			dut_Con.enable_fetch==1'b1;      //LD LDR ST STR
	endproperty
	CTRL_enable_fetch2 : cover property (enable_fetch2);

	
	//enable decode low for LDI/STI
	property enable_fetch3;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LDI ||
			dut_Con.IR_Exec[15:12]==STI) 
			|-> 
			dut_Con.enable_fetch==1'b0;
	endproperty
	CTRL_enable_fetch3 : cover property (enable_fetch3);

	
	//enable decode high for LDI/STI
	property enable_fetch4;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LDI ||
			dut_Con.IR_Exec[15:12]==STI)
			##2
			dut_Con.enable_fetch==1'b1;
	endproperty
	CTRL_enable_fetch4 : cover property (enable_fetch4);

	
	//checking for mem_state_3 after 
	property enable_mem_state_3;
		@(posedge top_io.clock)
			(dut_Con.IR_Exec[15:12]==LD ||
			dut_Con.IR_Exec[15:12]==LDR ||
			dut_Con.IR_Exec[15:12]==ST ||
			dut_Con.IR_Exec[15:12]==STR)
			|=> 
			dut_Con.mem_state==2'b11;
	endproperty
	CTRL_enable_mem_state_3 : cover property (enable_mem_state_3);

	
	//bypass_alu_1 for ALU after ALU (cross check)
	property bypass_alu_1_AA;
		@(posedge top_io.clock)
			((dut_Con.IR_Exec[15:12]==ADD ||
			dut_Con.IR_Exec[15:12]==AND ||
			dut_Con.IR_Exec[15:12]==NOT ||
			dut_Con.IR_Exec[15:12]==LEA)
			&&
			(dut_Con.IR[15:12]==ADD || dut_Con.IR[15:12]==AND || dut_Con.IR[15:12]==NOT)
			&& 
			dut_Con.IR_Exec[11:9]==dut_Con.IR[8:6])
			|-> 
			dut_Con.bypass_alu_1==1'b1;
	endproperty
	CTRL_bypass_alu_1_AA : cover property (bypass_alu_1_AA);
	
	
	//bypass_alu_2 for ALU after ALU (cross check)
	property bypass_alu_2_AA;
		@(posedge top_io.clock)
			((dut_Con.IR_Exec[15:12]==ADD ||
			dut_Con.IR_Exec[15:12]==AND ||
			dut_Con.IR_Exec[15:12]==NOT ||
			dut_Con.IR_Exec[15:12]==LEA)
			&&
			(dut_Con.IR[15:12]==4'b0001 || dut_Con.IR[15:12]==4'b0101 || dut_Con.IR[15:12]==4'b1001)
			&& 
			((dut_Con.IR_Exec[11:9]==dut_Con.IR[2:0]) && (dut_Con.IR[5]!=1'b1)))
			|-> 
			dut_Con.bypass_alu_2==1'b1;
	endproperty
	CTRL_bypass_alu_2_AA : cover property (bypass_alu_2_AA);	

	
	//bypass_alu_1 for STORE after ALU (cross check)
	property bypass_alu_1_AS;
		@(posedge top_io.clock)
			((dut_Con.IR_Exec[15:12] == ADD ||
			dut_Con.IR_Exec[15:12] == AND ||
			dut_Con.IR_Exec[15:12] == NOT)
			&&
			(dut_Con.IR[15:12] == STR) 
			&& 
			(dut_Con.IR_Exec[11:9] == dut_Con.IR[8:6])) 
			|-> 
			dut_Con.bypass_alu_1==1'b1;
	endproperty
	CTRL_bypass_alu_1_AS : cover property (bypass_alu_1_AS);

	
	//bypass_alu_2 for STORE after ALU (cross check)
	property bypass_alu_2_AS;
		@(posedge top_io.clock)
			((dut_Con.IR_Exec[15:12] == ADD ||
			dut_Con.IR_Exec[15:12] == AND ||
			dut_Con.IR_Exec[15:12] == NOT)
			&&
			(dut_Con.IR[15:12] == ST ||
			dut_Con.IR[15:12] == STR ||
			dut_Con.IR[15:12] == STI) 
			&& 
			(dut_Con.IR_Exec[11:9] == dut_Con.IR[11:9]))
			|-> 
			dut_Con.bypass_alu_2==1'b1;
	endproperty
	CTRL_bypass_alu_2_AS : cover property (bypass_alu_2_AS);
	
	
	//bypass_mem_1 for ALU after LD/LDR (cross check)
	property bypass_mem_1_LA;
		@(posedge top_io.clock)
		((dut_Con.IR_Exec[15:12]==LD ||
		dut_Con.IR_Exec[15:12]==LDR ||
		dut_Con.IR_Exec[15:12]==LDI) 
		&& 
		(dut_Con.IR[15:12]==ADD ||
		dut_Con.IR[15:12]==AND ||
		dut_Con.IR[15:12]==NOT) 
		&& 
		(dut_Con.IR_Exec[11:9]==dut_Con.IR[8:6]))
		|-> 
		dut_Con.bypass_mem_1==1'b1;
	endproperty
	CTRL_bypass_mem_1_LA : cover property (controller_bypass_mem_1_LA);
	
	
	//bypass_mem_2 for ALU after LD/LDR (cross check)
	property bypass_mem_2_LA;
		@(posedge top_io.clock)
		((dut_Con.IR_Exec[15:12]==LD ||
		dut_Con.IR_Exec[15:12]==LDR ||
		dut_Con.IR_Exec[15:12]==LDI)
		&&
		(dut_Con.IR[15:12]==ADD ||
		dut_Con.IR[15:12]==AND ||
		dut_Con.IR[15:12]==NOT) 
		&&
		(dut_Con.IR_Exec[11:9]==dut_Con.IR[2:0]) 
		&&
		(dut_Con.IR[5]!=1'b1))
		|-> 
		dut_Con.bypass_mem_2==1'b1;
	endproperty
	CTRL_bypass_mem_2_LA : cover property (bypass_mem_2_LA);

	
	//mem_state_3 to mem_state_1
	property controller_mem_state_3_1;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b11 |=> dut_Con.mem_state==2'b01;
	endproperty
	CTRL_mem_state_3_1 : cover property (controller_mem_state_3_1);
	
	
	//mem_state_3 to mem_state_0
	property controller_mem_state_3_0;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b11 |=> dut_Con.mem_state==2'b0;
	endproperty
	CTRL_mem_state_3_0 : cover property (controller_mem_state_3_0);
	
	
	//mem_state_3 to mem_state_2
	property controller_mem_state_3_2;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b11 |=> dut_Con.mem_state==2'b10;
	endproperty
	CTRL_mem_state_3_2 : cover property (controller_mem_state_3_2);
	
	
	//mem_state_2 to mem_state_3
	property controller_mem_state_2_3;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b10 |=> dut_Con.mem_state==2'b11;
	endproperty
	CTRL_mem_state_2_3 : cover property (controller_mem_state_2_3);
	
	
	//mem_state_1 to mem_state_0
	property controller_mem_state_1_0;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b01 |=> dut_Con.mem_state==2'b0;
	endproperty
	CTRL_mem_state_1_0 : cover property (controller_mem_state_1_0);
	
	
	//mem_state_1 to mem_state_2
	property controller_mem_state_1_2;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b01 |=> dut_Con.mem_state==2'b10;
	endproperty
	CTRL_mem_state_1_2 : cover property (controller_mem_state_1_2);
	
	
	//mem_state_0 to mem_state_3
	property controller_mem_state_0_3;
		@(posedge top_io.clock)
		dut_Con.mem_state==2'b0 |=> dut_Con.mem_state==2'b11;
	endproperty
	CTRL_mem_state_0_3 : cover property (controller_mem_state_0_3);
	
	
	//mem_state transitions for STI
	property controller_mem_state_STI;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==STI) 
		|-> 
		dut_Con.mem_state==2'b01 
		##1 
		dut_Con.mem_state==2'b10 
		##1
		dut_Con.mem_state==2'b11;
	endproperty
	CTRL_mem_state_STI : cover property (controller_mem_state_STI);
	
	
	//mem_state transitions for LDI
	property controller_mem_state_LDI;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==LDI) 
		|-> 
		dut_Con.mem_state==2'b01 
		##1 
		dut_Con.mem_state==2'b0 
		##1 
		dut_Con.mem_state==2'b11;
	endproperty
	CTRL_mem_state_LDI : cover property (controller_mem_state_LDI);
	
	
	//writeback enable low for ST/STR/STI
	property controller_enable_wb_ST1;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==ST ||
		dut_Con.IR_Exec[15:12]==STR ||
		dut_Con.IR_Exec[15:12]==STI) 
		|-> 
		dut_Con.enable_writeback==1'b0;
	endproperty
	CTRL_enable_wb_ST1 : cover property (controller_enable_wb_ST1);
	
	
	//writeback enable high for ST/STR
	property controller_enable_wb_ST2;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==ST ||
		dut_Con.IR_Exec[15:12]==STR) 
		##2
		dut_Con.enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_ST2 : cover property (controller_enable_wb_ST2);

	
	//writeback enable high for STI
	property controller_enable_wb_ST3;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==STI) 
		##3
		dut_Con.enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_ST3 : cover property (controller_enable_wb_ST3);
	
	
	//writeback enable low for LD/LDR/LDI
	property controller_enable_wb_LD1;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==LD ||
		dut_Con.IR_Exec[15:12]==LDR ||
		dut_Con.IR_Exec[15:12]==LDI)
		|-> 
		dut_Con.enable_writeback==1'b0;
	endproperty
	CTRL_enable_wb_LD1 : cover property (controller_enable_wb_LD1);

	
	//writeback enable high for LD/LDR
	property controller_enable_wb_LD2;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==4'b0010 ||
		dut_Con.IR_Exec[15:12]==4'b0110) 
		|=> 
		dut_Con.enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_LD2 : cover property (controller_enable_wb_LD2);
	
	
	//writeback enable high for LDI
	property controller_enable_wb_LD3;
		@(posedge top_io.clock)
		(dut_Con.IR_Exec[15:12]==4'b1010) 
		|=> 
		dut_Con.enable_writeback==1'b0 
		|=> 
		dut_Con.enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_LD3 : cover property (controller_enable_wb_LD3);*/
