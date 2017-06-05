`ifndef PROTECT_ENVIRONMENT
`define PROTECT_ENVIRONMENT

`include "Instruction.sv"
`include "Generator.sv"
`include "Driver.sv"
`include "fetchj2.sv"
`include "decodeblock.sv"
`include "executeblock.sv"
`include "writeback.sv"
`include "MemAccess_GoldRef.sv"
`include "CON_scoreboard.sv"

class environment;
	virtual LC3_io.TB top_io;
	virtual dut_Probe_if.FETCH dut_if;
	virtual dut_Probe_DE.DECODE dut_de;
	virtual dut_Probe_Exec dut_exec;
	virtual dut_Probe_WB.WB dut_wb;
	virtual memAccess_if mem_io;
	virtual dut_Probe_CON dut_Con;
	
	mailbox #(Instruction) gen2drv;
	generator gen;
	driver drv;
	goldenref_fetch Fetch;
	goldenref_decode Decode;
	goldenref_execute Execute;
	goldenref_writeback Writeback;
	goldenref_memAccess MemAccess;
	goldenref_control Control;
	
	int count;
	
	function new(virtual LC3_io.TB top_io,virtual dut_Probe_if.FETCH dut_if, virtual dut_Probe_DE.DECODE dut_de, virtual dut_Probe_Exec dut_exec, virtual dut_Probe_WB.WB dut_wb, virtual memAccess_if mem_io, virtual dut_Probe_CON C_int);
		this.top_io = top_io;
		this.dut_if = dut_if;
		this.dut_de = dut_de;
		this.dut_exec = dut_exec;
		this.dut_wb = dut_wb;
		this.mem_io = mem_io;
		this.dut_Con = C_int;
	endfunction : new 

	function void build();
		gen2drv = new(1);
		gen = new(gen2drv);
		drv = new(gen2drv,top_io,dut_wb,dut_if,dut_de,dut_exec,mem_io,dut_Con);
		Fetch = new(dut_if);
		Decode = new(dut_de);
		Execute= new(dut_exec);
		Writeback=new(dut_wb);
		MemAccess = new(mem_io);
		Control = new(dut_Con);

		//initialize your goldenref models here
	endfunction : build

	
	task run();
		build();
		count = 10;
		fork
			gen.run();
			drv.run();
			Fetch.run();
			Decode.run();
			Execute.run();
			Execute.checker_execute_sync();
			Execute.checker_execute_async();
			Writeback.run();
			Writeback.writeback_checker();
			MemAccess.run();
			MemAccess.check();
			Control.run();
			Control.control_checker();
			//add your goldenref models here
			//run your checkers here
			#15000000; //change this to adjust simulation time
		join_any
		//$display("out of fork");
	endtask : run
endclass
`endif
