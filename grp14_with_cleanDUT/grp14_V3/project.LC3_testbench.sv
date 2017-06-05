`include "Environment.sv"

program automatic LC3_test (LC3_io.TB top_io, dut_Probe_if.FETCH dut_if, dut_Probe_DE.DECODE dut_de, dut_Probe_Exec dut_exec, dut_Probe_WB.WB dut_wb, memAccess_if mem_io, dut_Probe_CON dut_Con);
	environment env;
	//Define goldenref

	initial begin
		env = new(top_io, dut_if, dut_de, dut_exec, dut_wb, mem_io, dut_Con);
		env.run();
	end
endprogram

