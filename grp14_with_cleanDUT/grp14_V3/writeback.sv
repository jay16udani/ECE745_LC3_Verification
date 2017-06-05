class goldenref_writeback;
virtual dut_Probe_WB.WB dutprobewb;

logic[15:0] regfile[8];

function new(virtual dut_Probe_WB.WB dutprobewb);
this.dutprobewb=dutprobewb;
endfunction

task run();
fork
//thread for asynchronous VSR1 signal
	forever
	begin
		@regfile[dutprobewb.writeback_sr1];
		begin
			dutprobewb.goldenref_writeback_VSR1 = regfile[dutprobewb.writeback_sr1];
		end
	end
//thread for asynchronous VSR2 signal
	forever
	begin
		@regfile[dutprobewb.writeback_sr2];
		begin
			dutprobewb.goldenref_writeback_VSR2 = regfile[dutprobewb.writeback_sr2];
		end
		
	end

//thread for sync signals
	forever
	begin
		@(dutprobewb.cb_writeback);

		if(dutprobewb.writeback_reset) // Reset = 1
		begin
			dutprobewb.goldenref_writeback_psr <= 3'b000;    // reset value
		end
		else // Reset = 0
		begin
			if(dutprobewb.cb_writeback.writeback_enable_writeback) // enable = 1
			begin
			case(dutprobewb.cb_writeback.writeback_W_control_in)
			0:regfile[dutprobewb.cb_writeback.writeback_dr] <= dutprobewb.cb_writeback.writeback_aluout;
			1:regfile[dutprobewb.cb_writeback.writeback_dr] <= dutprobewb.cb_writeback.writeback_memout;
			2:regfile[dutprobewb.cb_writeback.writeback_dr] <= dutprobewb.cb_writeback.writeback_pcout;
			endcase

			case(dutprobewb.cb_writeback.writeback_W_control_in) //enable = 1
			0: begin 
				if(dutprobewb.cb_writeback.writeback_aluout[15]==1)
					begin dutprobewb.goldenref_writeback_psr <= 3'b100; end
				else if((dutprobewb.cb_writeback.writeback_aluout[15]==0) && (dutprobewb.cb_writeback.writeback_aluout!=0) )
					begin dutprobewb.goldenref_writeback_psr <= 3'b001; end
				else if(dutprobewb.cb_writeback.writeback_aluout==0)
					begin dutprobewb.goldenref_writeback_psr <= 3'b010; end
				end//case 0 end
				
			1: begin 
				if(dutprobewb.cb_writeback.writeback_memout[15]==1)
					begin dutprobewb.goldenref_writeback_psr <= 3'b100; end
				else if((dutprobewb.cb_writeback.writeback_memout[15]==0) && (dutprobewb.cb_writeback.writeback_memout!=0) )
					begin dutprobewb.goldenref_writeback_psr <= 3'b001; end
				else if(dutprobewb.cb_writeback.writeback_memout==0)
					begin dutprobewb.goldenref_writeback_psr <= 3'b010; end
				end//case 1 end
				
			2: begin 
				if(dutprobewb.cb_writeback.writeback_pcout[15]==1)
					begin dutprobewb.goldenref_writeback_psr <= 3'b100; end
				else if((dutprobewb.cb_writeback.writeback_pcout[15]==0) && (dutprobewb.cb_writeback.writeback_pcout!=0) )
					begin dutprobewb.goldenref_writeback_psr <= 3'b001; end
				else if(dutprobewb.cb_writeback.writeback_pcout==0)
					begin dutprobewb.goldenref_writeback_psr <= 3'b010; end
				end//case 2 end
			endcase
			end // end for enable writeback
		
		end // else end
	end // thread end
	
join
endtask : run

//checker for writeback stage
task writeback_checker();
forever
begin
@(negedge dutprobewb.writeback_clk);
if(dutprobewb.goldenref_writeback_psr !== dutprobewb.writeback_psr)
			$display($time,"In Write back stage, Golden Reference value of PSR %h does not match Value from DUT of PSR %h ", dutprobewb.goldenref_writeback_psr,dutprobewb.writeback_psr);
if(dutprobewb.goldenref_writeback_VSR1 !== dutprobewb.writeback_VSR1)
			$display($time,"In Write back stage, Golden Reference value of VSR1 %h does not match Value from DUT of VSR1 %h ",dutprobewb.goldenref_writeback_VSR1,dutprobewb.writeback_VSR1);
if(dutprobewb.goldenref_writeback_VSR2 !== dutprobewb.writeback_VSR2)
			$display($time,"In Write back stage, Golden Reference value of VSR2 %h does not match Value from DUT of VSR2 %h ",dutprobewb.goldenref_writeback_VSR2,dutprobewb.writeback_VSR2);
end
endtask: writeback_checker
endclass : goldenref_writeback

