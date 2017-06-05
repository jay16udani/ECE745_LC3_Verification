class goldenref_fetch;
virtual dut_Probe_if.FETCH dutprobeif;

function new(virtual dut_Probe_if.FETCH dutprobeif);
	this.dutprobeif=dutprobeif;
endfunction

task run();
	fork
	begin
		forever
		begin
			@dutprobeif.fetch_enable_fetch;
			if(dutprobeif.fetch_enable_fetch) dutprobeif.goldenref_instrmem_rd <= 1;
			else dutprobeif.goldenref_instrmem_rd <= 1'b0; // High impedence
		end
	end
	begin
		forever 
		begin
			@dutprobeif.cb;
			//$display("double clock check: %0d",$time);
			if(dutprobeif.fetch_reset) // When reset = 1
			begin
				//$display("goldenreference fetch is reset");
				dutprobeif.cb.goldenref_pc <= 16'h3000;	
				dutprobeif.cb.goldenref_npc <= dutprobeif.cb.goldenref_pc+1;
			end
			else // When reset = 0
			begin
				if(dutprobeif.cb.fetch_enable_updatePC) // Enable = 1
				begin
					if(dutprobeif.cb.fetch_br_taken) // Branch Taken condition
					begin
						dutprobeif.cb.goldenref_pc <= dutprobeif.fetch_taddr;
						dutprobeif.cb.goldenref_npc <= dutprobeif.cb.goldenref_pc+1;
					end
					else // Branch not taken
					begin
						dutprobeif.cb.goldenref_pc <= dutprobeif.cb.goldenref_npc;
						dutprobeif.cb.goldenref_npc <= dutprobeif.cb.goldenref_pc+1;
					end	
				end
				else // Enable = 0
				begin
					dutprobeif.cb.goldenref_pc <= dutprobeif.cb.goldenref_pc;
					dutprobeif.cb.goldenref_npc <= dutprobeif.cb.goldenref_pc+1;
				end
			end
			checker_fetch_sync();
			checker_fetch_async();
		end
	end
	join
endtask : run

task checker_fetch_sync();
		if(dutprobeif.cb.goldenref_pc !== dutprobeif.fetch_pc)
		$display($time,"In Fetch stage, Golden reference value of PC %h and Value from dut of PC %h are not matching ", dutprobeif.cb.goldenref_pc, dutprobeif.fetch_pc );
		if(dutprobeif.cb.goldenref_npc !== dutprobeif.fetch_npc)
			$display($time,"In Fetch stage, Golden reference value of NPC %h and Value from dut of NPC %h are not matching", dutprobeif.cb.goldenref_npc, dutprobeif.fetch_npc);       
endtask : checker_fetch_sync
	
task checker_fetch_async();
		if(dutprobeif.goldenref_instrmem_rd!== dutprobeif.cb.fetch_instrmem_rd)
		  $display($time,"In Fetch stage, Golden reference value of Instruction Memory read %h and Value from dut of Instruction Memory read %h are not matching",dutprobeif.goldenref_instrmem_rd,dutprobeif.cb.fetch_instrmem_rd);
endtask : checker_fetch_async
endclass: goldenref_fetch


