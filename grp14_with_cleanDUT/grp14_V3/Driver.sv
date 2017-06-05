`ifndef PROTECT_GENERATOR
`define PROTECT_GENERATOR

`include "Instruction.sv"
`include "Coverage.sv"

class driver;
	Coverage Cov;
	Instruction instr;
	mailbox #(Instruction) gen2drv;
	virtual LC3_io.TB top_io;
	virtual dut_Probe_WB.WB dut_wb;
	virtual dut_Probe_if.FETCH dut_if;
	virtual dut_Probe_DE.DECODE dut_de;
	virtual dut_Probe_Exec dut_exec;
	virtual memAccess_if mem_io;
	virtual dut_Probe_CON dut_Con;
				
	local logic instrmem_rd_prev = 1;
	local int temp;

	function new(mailbox #(Instruction) mbx, virtual LC3_io.TB top_io,virtual dut_Probe_WB.WB dut_wb,virtual dut_Probe_if.FETCH dut_if,	virtual dut_Probe_DE.DECODE dut_de,	virtual dut_Probe_Exec dut_exec,virtual memAccess_if mem_io,virtual dut_Probe_CON dut_Con);
		this.gen2drv = mbx;
		this.top_io = top_io;
		this.dut_wb = dut_wb;
		this.dut_if = dut_if;
		this.dut_de = dut_de;
		this.dut_exec = dut_exec;
		this.mem_io = mem_io;
		this.dut_Con = dut_Con;
		Cov = new(dut_wb,dut_if,dut_de,dut_exec,mem_io,dut_Con,top_io);
	endfunction : new

	task Reset_dut();
		@top_io.cb;
		top_io.cb.reset <= 1;
		top_io.complete_data <= 0;
    		top_io.complete_instr <= 0;
	    	repeat(3)@top_io.cb;
		top_io.cb.reset <= 0;
	endtask : Reset_dut


	task Init_dut();
		top_io.complete_instr <= 1;
		top_io.complete_data <= 1;
		top_io.cb.Data_dout <= $urandom_range(0,65535);
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R0",$time);
		top_io.cb.Instr_dout <= 16'h5020;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R1",$time);
		top_io.cb.Instr_dout <= 16'h5260;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R2",$time);
		top_io.cb.Instr_dout <= 16'h54A0;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R3",$time);
		top_io.cb.Instr_dout <= 16'h56E0;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R4",$time);
		top_io.cb.Instr_dout <= 16'h5920;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R5",$time);
		top_io.cb.Instr_dout <= 16'h5B60;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R6",$time);
		top_io.cb.Instr_dout <= 16'h5DA0;
		repeat(1)@top_io.cb;
		$display("%d : ns Writing 0 to reg R7",$time);
		top_io.cb.Instr_dout <= 16'h5FE0;	
	endtask : Init_dut

	task Randomtest_dut();
		forever begin
			@top_io.cb;
			if(top_io.cb.instrmem_rd)
			begin
				gen2drv.get(instr);
				top_io.complete_instr <= 1;
				top_io.complete_data <= 1;
				top_io.cb.Instr_dout <= instr.Instr_base;
				temp = $urandom_range(0,20);
				if(temp==0) top_io.cb.Data_dout <= 16'h0000;
				else if (temp==1) top_io.cb.Data_dout <= 16'hFFFF;
				else if (temp==2) top_io.cb.Data_dout <= 16'hAAAA;
				else if (temp==3) top_io.cb.Data_dout <= 16'h5555;
				else top_io.cb.Data_dout <= $urandom_range(0,65535);
				Cov.sample(instr.Instr_base);
			end
			else
			begin
				//$display("driver stalled");
			end
			instrmem_rd_prev = top_io.cb.instrmem_rd;
		end
	endtask : Randomtest_dut

	task run();
		Reset_dut();
		Init_dut();
		Randomtest_dut();
		//$display("out of driver");
	endtask
endclass

`endif
