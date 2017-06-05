class goldenref_memAccess;
	virtual memAccess_if mem_io;
	
	//Obtain the handle for the physical interface
	function new(virtual memAccess_if m);
	begin
		this.mem_io = m;
	end
	endfunction

	task run();
	forever begin
		fork
			@mem_io.M_Data;
			@mem_io.M_addr;
			@mem_io.M_Control;
			@mem_io.memout;
			@mem_io.mem_state;
		join_any
		
		mem_io.GoldRef_Data_dout = mem_io.memout;
		if(mem_io.mem_state == 0)
		begin
			mem_io.GoldRef_Data_rd = 1'b1;
			mem_io.GoldRef_Data_din = 16'h0000;
			if(mem_io.M_Control==1) mem_io.GoldRef_Data_addr = mem_io.memout;
			else mem_io.GoldRef_Data_addr = mem_io.M_addr;
		end
		else if(mem_io.mem_state == 1)
		begin
			mem_io.GoldRef_Data_rd = 1'b1;
			mem_io.GoldRef_Data_din = 16'h0000;
			mem_io.GoldRef_Data_addr = mem_io.M_addr;
		end
		else if(mem_io.mem_state == 2)
		begin
			mem_io.GoldRef_Data_rd = 1'b0;
			mem_io.GoldRef_Data_din = mem_io.M_Data;
			if(mem_io.M_Control==1) mem_io.GoldRef_Data_addr = mem_io.memout;
			else mem_io.GoldRef_Data_addr = mem_io.M_addr;
		end
		else if(mem_io.mem_state == 3)
		begin
			mem_io.GoldRef_Data_rd = 1'bz;
			mem_io.GoldRef_Data_din = 16'hzzzz;
			mem_io.GoldRef_Data_addr = 16'hzzzz;
		end
	end
	endtask : run

	task check();
		forever begin
			@(negedge mem_io.clock);
			if(mem_io.GoldRef_Data_dout!==mem_io.Data_dout)
				$display($time," Error in Mem Access stage data_dout: DUT: %0h Goldenref: %0h",mem.io.Data_dout,mem_io.GoldRef_Data_dout);
			if(mem_io.GoldRef_Data_addr!==mem_io.Data_addr)
				$display($time," Error in Mem Access stage data_addr: DUT: %0h Goldenref: %0h", mem_io.Data_addr,mem_io.GoldRef_Data_addr);
			if(mem_io.GoldRef_Data_din!==mem_io.Data_din)
				$display($time," Error in Mem Access stage data_addr: DUT: %0h Goldenref: %0h", mem_io.Data_din, mem_io.GoldRef_Data_din);
			if(mem_io.GoldRef_Data_rd!==mem_io.Data_rd)
				$display($time," Error in Mem Access stage data_addr: DUT: %0h Goldenref: %0h",mem_io.Data_rd,mem_io.GoldRef_Data_rd);
		end
	endtask :  check
endclass
