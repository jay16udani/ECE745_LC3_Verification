class MemAccess_Monitor
	virtual memAccess_if mem_io;

	//Obtain the handle for the physical interface
	function new(virtual memAccess_if m);
	begin
		this.mem_io = m;
	end
	endfunction

	virtual function run();
		forever begin
			@posedge mem_io.clock;
			if(mem_io.GoldRef_Data_dout!=mem_io.Data_dout)
				$display($time," Error in Mem Access stage data_addr!" );
			if(mem_io.GoldRef_Data_addr!=mem_io.Data_addr)
				$display($time," Error in Mem Access stage data_addr!" );
			if(mem_io.GoldRef_Data_din!=mem_io.Data_din)
				$display($time," Error in Mem Access stage data_addr!" );
			if(mem_io.GoldRef_Data_rd!=mem_io.Data_rd)
				$display($time," Error in Mem Access stage data_addr!" );
		end
	endfunction
endclass
