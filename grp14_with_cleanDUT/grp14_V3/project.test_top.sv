`timescale 1ns/10ps
`include "TopLevelLC3.v"
`include "project.LC3_testbench.sv"
`include "project.if_finalizing.sv"
module LC3_test_top;
	parameter simulation_cycle = 20;

	reg  SysClock;
	LC3_io top_io(SysClock);  // Instantiate the top level interface of the testbench to be used for driving the LC3 and reading the LC3 outputs.
	
	// Instantiating and Connecting the probe signals for the Fetch block with the DUT fetch block signals using the "dut" instantation of LC3 below.
	dut_Probe_if dut_if (	
					.fetch_enable_updatePC(dut.Fetch.enable_updatePC), 
					.fetch_enable_fetch(dut.Fetch.enable_fetch), 
					.fetch_pc(dut.Fetch.pc), 
					.fetch_npc(dut.Fetch.npc_out),
					.fetch_instrmem_rd(dut.Fetch.instrmem_rd),
					.fetch_taddr(dut.Fetch.taddr),
					.fetch_br_taken(dut.Fetch.br_taken),
					.fetch_reset(dut.Fetch.reset),
					.clock(SysClock)
				);

	dut_Probe_DE dut_de (.decode_npc_in(dut.Dec.npc_in),
					.decode_enable_decode(dut.Dec.enable_decode),
					.decode_Instr_dout(dut.Dec.dout),
					//.decode_PSR(dut.Dec.psr),
					.decode_IR(dut.Dec.IR),
					.decode_E_control(dut.Dec.E_Control),
					.decode_npc_out(dut.Dec.npc_out),
					.decode_Mem_control(dut.Dec.Mem_Control),
					.decode_W_control(dut.Dec.W_Control),
					.decode_reset(dut.Dec.reset),
					.decode_clk(SysClock)				);

					
	dut_Probe_Exec dut_exec (.execute_E_control(dut.Ex.E_Control),
							.execute_IR(dut.Ex.IR),
							.execute_npc_in(dut.Ex.npc),
							.execute_bypass_alu_1(dut.Ex.bypass_alu_1),
							.execute_bypass_alu_2(dut.Ex.bypass_alu_2),
							.execute_bypass_mem_1(dut.Ex.bypass_mem_1),
							.execute_bypass_mem_2(dut.Ex.bypass_mem_2),
							.execute_VSR1(dut.Ex.VSR1),
							.execute_VSR2(dut.Ex.VSR2),
							.execute_W_Control_in(dut.Ex.W_Control_in),
							.execute_Mem_Control_in(dut.Ex.Mem_Control_in),
							.execute_enable_execute(dut.Ex.enable_execute),
							.execute_Mem_Bypass_Val(dut.Ex.Mem_Bypass_Val),
							.execute_W_Control_out(dut.Ex.W_Control_out),
							.execute_Mem_Control_out(dut.Ex.Mem_Control_out),
							.execute_aluout(dut.Ex.aluout),
							.execute_pcout(dut.Ex.pcout),
							.execute_dr(dut.Ex.dr),
							.execute_sr1(dut.Ex.sr1),
							.execute_sr2(dut.Ex.sr2),
							.execute_IR_Exec(dut.Ex.IR_Exec),
							.execute_NZP(dut.Ex.NZP),
							.execute_M_Data(dut.Ex.M_Data),
							.execute_reset(dut.Ex.reset),
							.execute_clk(SysClock)				);


	dut_Probe_WB dut_wb (.writeback_npc(dut.WB.Writeback.npc),
                    .writeback_W_control_in(dut.WB.Writeback.W_Control),
                    .writeback_aluout(dut.WB.Writeback.aluout),
                    .writeback_pcout(dut.WB.Writeback.pcout),
                    .writeback_memout(dut.WB.Writeback.memout),
                    .writeback_enable_writeback(dut.WB.Writeback.enable_writeback),
                    .writeback_sr1(dut.WB.Writeback.sr1),
                    .writeback_sr2(dut.WB.Writeback.sr2),
                    .writeback_dr(dut.WB.Writeback.dr),
                    .writeback_VSR1(dut.WB.Writeback.d1),
                    .writeback_VSR2(dut.WB.Writeback.d2),
                    .writeback_psr(dut.WB.Writeback.psr),
			.writeback_reset(dut.WB.Writeback.reset),
			.writeback_clk(SysClock)
					);

	memAccess_if mem_io (		.M_Data(dut.MemAccess.M_Data),
					.M_addr(dut.MemAccess.M_Addr),
					.memout(dut.MemAccess.memout),
					.M_Control(dut.MemAccess.M_Control),
					.mem_state(dut.MemAccess.mem_state),
					.Data_addr(dut.MemAccess.Data_addr),
					.Data_din(dut.MemAccess.Data_din),
					.Data_dout(dut.MemAccess.Data_dout),
					.Data_rd(dut.MemAccess.Data_rd),
					.clock(SysClock)
				);
				
	dut_Probe_CON 	dut_Con(
					.control_complete_data(dut.Ctrl.complete_data),    
					.control_complete_instr(dut.Ctrl.complete_instr),
                    .control_IR(dut.Ctrl.IR),
                    .control_PSR(dut.Ctrl.psr),
                    .control_IR_Exec(dut.Ctrl.IR_Exec),
                    .control_IMem_dout(dut.Ctrl.Instr_dout),
                    .control_NZP(dut.Ctrl.NZP),
                    .control_enable_updatePC(dut.Ctrl.enable_updatePC),
					.control_enable_fetch(dut.Ctrl.enable_fetch),
					.control_enable_decode(dut.Ctrl.enable_decode),
					.control_enable_execute(dut.Ctrl.enable_execute),
					.control_enable_writeback(dut.Ctrl.enable_writeback),
					.control_bypass_alu_1(dut.Ctrl.bypass_alu_1),
					.control_bypass_alu_2(dut.Ctrl.bypass_alu_2),
					.control_bypass_mem_1(dut.Ctrl.bypass_mem_1),
					.control_bypass_mem_2(dut.Ctrl.bypass_mem_2),
					.control_mem_state(dut.Ctrl.mem_state),
					.control_br_taken(dut.Ctrl.br_taken),
					.control_reset(dut.Ctrl.reset),
					.control_clk(SysClock)
				);

	// Passing the top level interface and probe interface to the testbench.
	//LC3_test test(top_io,dut_if);

	LC3_test test(top_io,dut_if, dut_de,dut_exec, dut_wb, mem_io, dut_Con);
	 
	// Instatiating the top-level DUT.
	LC3 dut(
		.clock(top_io.clock), 
		.reset(top_io.reset), 
		.pc(top_io.pc), 
		.instrmem_rd(top_io.instrmem_rd), 
		.Instr_dout(top_io.Instr_dout), 
		.Data_addr(top_io.Data_addr), 
		.complete_instr(top_io.complete_instr), 
		.complete_data(top_io.complete_data),
		.Data_din(top_io.Data_din),
		.Data_dout(top_io.Data_dout),
		.Data_rd(top_io.Data_rd)
		);

//Assertions for behavioural modeling
	property reset;
		@(posedge top_io.clock)
			(top_io.reset==1'b1) |-> (dut_if.fetch_pc==16'h3000 && 
									dut_de.decode_IR==0 && 
									dut_de.decode_npc_out==0 && 
									dut_de.decode_E_control==0 && 
									dut_de.decode_W_control==0 && 
									dut_de.decode_Mem_control==0 && 
									dut_exec.execute_W_Control_out==0 && 
									dut_exec.execute_Mem_Control_out==0 && 
									dut_exec.execute_aluout==0 && 
									dut_exec.execute_pcout==0 && 
									dut_exec.execute_IR_Exec==0 && 
									dut_exec.execute_NZP==0 && 
									dut_exec.execute_M_Data==0 && 
									dut_exec.execute_dr==0 && 
									dut_wb.writeback_psr==0);
	endproperty					
	top_reset :cover property (reset);
	
	
	property br_taken;
		@(posedge top_io.clock)
			|(dut_exec.execute_NZP==1) |-> (dut_Con.control_br_taken ==1);
	endproperty
	CTRL_br_taken_jmp : cover property (br_taken);
	
	
	//enable decode low for LD/LDR/ST/STR
	property enable_decode1;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LD || 
			dut_Con.control_IR_Exec[15:12]==LDR || 
			dut_Con.control_IR_Exec[15:12]==ST || 
			dut_Con.control_IR_Exec[15:12]==STR) 		
			|->
			dut_Con.control_enable_decode==1'b0;
	endproperty
	CTRL_enable_decode1 : cover property (enable_decode1);

	
	//enable decode high for LD/LDR/ST/STR
	property enable_decode2;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LD ||
			dut_Con.control_IR_Exec[15:12]==LDR ||
			dut_Con.control_IR_Exec[15:12]==ST ||
			dut_Con.control_IR_Exec[15:12]==STR) 		
			|=> 
			dut_Con.control_enable_decode==1'b1;
	endproperty
	CTRL_enable_decode2 : cover property (enable_decode2);

	
	//enable decode low for LDI/STI
	property enable_decode3;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LDI ||
			dut_Con.control_IR_Exec[15:12]==STI) 		
			|-> 
			dut_Con.control_enable_decode==1'b0;
	endproperty
	CTRL_enable_decode3 : cover property (enable_decode3);

	
	//enable decode high for LDI/STI
	property enable_decode4;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LDI ||
			dut_Con.control_IR_Exec[15:12]==STI)		 
			##2
			dut_Con.control_enable_decode==1'b1;
	endproperty
	CTRL_enable_decode4 : cover property (enable_decode4);

	
	//enable fetch low for LD/LDR/ST/STR
	property enable_fetch1;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LD || 
			dut_Con.control_IR_Exec[15:12]==LDR || 
			dut_Con.control_IR_Exec[15:12]==ST || 
			dut_Con.control_IR_Exec[15:12]==STR) 
			|-> 
			dut_Con.control_enable_fetch==1'b0;       
	endproperty
	CTRL_enable_fetch1 : cover property (enable_fetch1);

	
	//enable fetch high for LD/LDR/ST/STR
	property enable_fetch2;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LD ||
			dut_Con.control_IR_Exec[15:12]==LDR ||
			dut_Con.control_IR_Exec[15:12]==ST ||
			dut_Con.control_IR_Exec[15:12]==STR) 
			|=> 
			dut_Con.control_enable_fetch==1'b1;      //LD LDR ST STR
	endproperty
	CTRL_enable_fetch2 : cover property (enable_fetch2);

	
	//enable decode low for LDI/STI
	property enable_fetch3;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LDI ||
			dut_Con.control_IR_Exec[15:12]==STI) 
			|-> 
			dut_Con.control_enable_fetch==1'b0;
	endproperty
	CTRL_enable_fetch3 : cover property (enable_fetch3);

	
	//enable decode high for LDI/STI
	property enable_fetch4;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LDI ||
			dut_Con.control_IR_Exec[15:12]==STI)
			##2
			dut_Con.control_enable_fetch==1'b1;
	endproperty
	CTRL_enable_fetch4 : cover property (enable_fetch4);

	
	//checking for mem_state_3 after 
	property enable_mem_state_3;
		@(posedge top_io.clock)
			(dut_Con.control_IR_Exec[15:12]==LD ||
			dut_Con.control_IR_Exec[15:12]==LDR ||
			dut_Con.control_IR_Exec[15:12]==ST ||
			dut_Con.control_IR_Exec[15:12]==STR)
			|=> 
			dut_Con.control_mem_state==2'b11;
	endproperty
	CTRL_enable_mem_state_3 : cover property (enable_mem_state_3);

	
	//bypass_alu_1 for ALU after ALU (cross check)
	property bypass_alu_1_AA;
		@(posedge top_io.clock)
			((dut_Con.control_IR_Exec[15:12]==ADD ||
			dut_Con.control_IR_Exec[15:12]==AND ||
			dut_Con.control_IR_Exec[15:12]==NOT ||
			dut_Con.control_IR_Exec[15:12]==LEA)
			&&
			(dut_Con.control_IR[15:12]==ADD || dut_Con.control_IR[15:12]==AND || dut_Con.control_IR[15:12]==NOT)
			&& 
			dut_Con.control_IR_Exec[11:9]==dut_Con.control_IR[8:6])
			|-> 
			dut_Con.control_bypass_alu_1==1'b1;
	endproperty
	CTRL_bypass_alu_1_AA : cover property (bypass_alu_1_AA);
	
	
	//bypass_alu_2 for ALU after ALU (cross check)
	property bypass_alu_2_AA;
		@(posedge top_io.clock)
			((dut_Con.control_IR_Exec[15:12]==ADD ||
			dut_Con.control_IR_Exec[15:12]==AND ||
			dut_Con.control_IR_Exec[15:12]==NOT ||
			dut_Con.control_IR_Exec[15:12]==LEA)
			&&
			(dut_Con.control_IR[15:12]==4'b0001 || dut_Con.control_IR[15:12]==4'b0101 || dut_Con.control_IR[15:12]==4'b1001)
			&& 
			((dut_Con.control_IR_Exec[11:9]==dut_Con.control_IR[2:0]) && (dut_Con.control_IR[5]!=1'b1)))
			|-> 
			dut_Con.control_bypass_alu_2==1'b1;
	endproperty
	CTRL_bypass_alu_2_AA : cover property (bypass_alu_2_AA);	

	
	//bypass_alu_1 for STORE after ALU (cross check)
	property bypass_alu_1_AS;
		@(posedge top_io.clock)
			((dut_Con.control_IR_Exec[15:12] == ADD ||
			dut_Con.control_IR_Exec[15:12] == AND ||
			dut_Con.control_IR_Exec[15:12] == NOT)
			&&
			(dut_Con.control_IR[15:12] == STR) 
			&& 
			(dut_Con.control_IR_Exec[11:9] == dut_Con.control_IR[8:6])) 
			|-> 
			dut_Con.control_bypass_alu_1==1'b1;
	endproperty
	CTRL_bypass_alu_1_AS : cover property (bypass_alu_1_AS);

	
	//bypass_alu_2 for STORE after ALU (cross check)
	property bypass_alu_2_AS;
		@(posedge top_io.clock)
			((dut_Con.control_IR_Exec[15:12] == ADD ||
			dut_Con.control_IR_Exec[15:12] == AND ||
			dut_Con.control_IR_Exec[15:12] == NOT)
			&&
			(dut_Con.control_IR[15:12] == ST ||
			dut_Con.control_IR[15:12] == STR ||
			dut_Con.control_IR[15:12] == STI) 
			&& 
			(dut_Con.control_IR_Exec[11:9] == dut_Con.control_IR[11:9]))
			|-> 
			dut_Con.control_bypass_alu_2==1'b1;
	endproperty
	CTRL_bypass_alu_2_AS : cover property (bypass_alu_2_AS);
	
	
	//bypass_mem_1 for ALU after LD/LDR (cross check)
	property bypass_mem_1_LA;
		@(posedge top_io.clock)
		((dut_Con.control_IR_Exec[15:12]==LD ||
		dut_Con.control_IR_Exec[15:12]==LDR ||
		dut_Con.control_IR_Exec[15:12]==LDI) 
		&& 
		(dut_Con.control_IR[15:12]==ADD ||
		dut_Con.control_IR[15:12]==AND ||
		dut_Con.control_IR[15:12]==NOT) 
		&& 
		(dut_Con.control_IR_Exec[11:9]==dut_Con.control_IR[8:6]))
		|-> 
		dut_Con.control_bypass_mem_1==1'b1;
	endproperty
	CTRL_bypass_mem_1_LA : cover property (bypass_mem_1_LA);
	
	
	//bypass_mem_2 for ALU after LD/LDR (cross check)
	property bypass_mem_2_LA;
		@(posedge top_io.clock)
		((dut_Con.control_IR_Exec[15:12]==LD ||
		dut_Con.control_IR_Exec[15:12]==LDR ||
		dut_Con.control_IR_Exec[15:12]==LDI)
		&&
		(dut_Con.control_IR[15:12]==ADD ||
		dut_Con.control_IR[15:12]==AND ||
		dut_Con.control_IR[15:12]==NOT) 
		&&
		(dut_Con.control_IR_Exec[11:9]==dut_Con.control_IR[2:0]) 
		&&
		(dut_Con.control_IR[5]!=1'b1))
		|-> 
		dut_Con.control_bypass_mem_2==1'b1;
	endproperty
	CTRL_bypass_mem_2_LA : cover property (bypass_mem_2_LA);

	
	//mem_state_3 to mem_state_1
	property mem_state_3_1;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b11 |=> dut_Con.control_mem_state==2'b01;
	endproperty
	CTRL_mem_state_3_1 : cover property (mem_state_3_1);
	
	
	//mem_state_3 to mem_state_0
	property mem_state_3_0;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b11 |=> dut_Con.control_mem_state==2'b0;
	endproperty
	CTRL_mem_state_3_0 : cover property (mem_state_3_0);
	
	
	//mem_state_3 to mem_state_2
	property mem_state_3_2;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b11 |=> dut_Con.control_mem_state==2'b10;
	endproperty
	CTRL_mem_state_3_2 : cover property (mem_state_3_2);
	
	
	//mem_state_2 to mem_state_3
	property mem_state_2_3;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b10 |=> dut_Con.control_mem_state==2'b11;
	endproperty
	CTRL_mem_state_2_3 : cover property (mem_state_2_3);
	
	
	//mem_state_1 to mem_state_0
	property mem_state_1_0;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b01 |=> dut_Con.control_mem_state==2'b0;
	endproperty
	CTRL_mem_state_1_0 : cover property (mem_state_1_0);
	
	
	//mem_state_1 to mem_state_2
	property mem_state_1_2;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b01 |=> dut_Con.control_mem_state==2'b10;
	endproperty
	CTRL_mem_state_1_2 : cover property (mem_state_1_2);
	
	
	//mem_state_0 to mem_state_3
	property mem_state_0_3;
		@(posedge top_io.clock)
		dut_Con.control_mem_state==2'b0 |=> dut_Con.control_mem_state==2'b11;
	endproperty
	CTRL_mem_state_0_3 : cover property (mem_state_0_3);
	
	
	//mem_state transitions for STI
	property mem_state_STI;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==STI) 
		|-> 
		dut_Con.control_mem_state==2'b01 
		##1 
		dut_Con.control_mem_state==2'b10 
		##1
		dut_Con.control_mem_state==2'b11;
	endproperty
	CTRL_mem_state_STI : cover property (mem_state_STI);
	
	
	//mem_state transitions for LDI
	property mem_state_LDI;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==LDI) 
		|-> 
		dut_Con.control_mem_state==2'b01 
		##1 
		dut_Con.control_mem_state==2'b0 
		##1 
		dut_Con.control_mem_state==2'b11;
	endproperty
	CTRL_mem_state_LDI : cover property (mem_state_LDI);
	
	
	//writeback enable low for ST/STR/STI
	property enable_wb_ST1;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==ST ||
		dut_Con.control_IR_Exec[15:12]==STR ||
		dut_Con.control_IR_Exec[15:12]==STI) 
		|-> 
		dut_Con.control_enable_writeback==1'b0;
	endproperty
	CTRL_enable_wb_ST1 : cover property (enable_wb_ST1);
	
	
	//writeback enable high for ST/STR
	property enable_wb_ST2;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==ST ||
		dut_Con.control_IR_Exec[15:12]==STR) 
		##2
		dut_Con.control_enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_ST2 : cover property (enable_wb_ST2);

	
	//writeback enable high for STI
	property enable_wb_ST3;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==STI) 
		##3
		dut_Con.control_enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_ST3 : cover property (enable_wb_ST3);
	
	
	//writeback enable low for LD/LDR/LDI
	property enable_wb_LD1;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==LD ||
		dut_Con.control_IR_Exec[15:12]==LDR ||
		dut_Con.control_IR_Exec[15:12]==LDI)
		|-> 
		dut_Con.control_enable_writeback==1'b0;
	endproperty
	CTRL_enable_wb_LD1 : cover property (enable_wb_LD1);

	
	//writeback enable high for LD/LDR
	property enable_wb_LD2;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==4'b0010 ||
		dut_Con.control_IR_Exec[15:12]==4'b0110) 
		|=> 
		dut_Con.control_enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_LD2 : cover property (enable_wb_LD2);
	
	
	//writeback enable high for LDI
	property enable_wb_LD3;
		@(posedge top_io.clock)
		(dut_Con.control_IR_Exec[15:12]==4'b1010) 
		|=> 
		dut_Con.control_enable_writeback==1'b0 
		|=> 
		dut_Con.control_enable_writeback==1'b1;
	endproperty
	CTRL_enable_wb_LD3 : cover property (enable_wb_LD3);

	initial 
	begin
		SysClock = 0;
		forever 
		begin
			#(simulation_cycle/2)
			SysClock = ~SysClock;
		end
	end
endmodule

