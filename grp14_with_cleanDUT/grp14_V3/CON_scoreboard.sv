class goldenref_control;

	virtual dut_Probe_CON C_int;
	int flag_reset;
	int flag_LDI;
	int flag_LD_LDR;
	int flag_STI;
	int flag_ST_STR;
	int flag_br_taken;
	int flag_br_taken_LD_LDR;
	int flag_br_taken_LDI;
	int flag_br_taken_ST_STR;
	int flag_br_taken_STI;
	int flag_next;
	int flag_br_taken_LD_LDR_st1;
	int flag_br_taken_LDI_st1;
	int flag_br_taken_ST_STR_st1;
	int flag_br_taken_STI_st1;
	int flag_st1;
	int branch_nottaken;
	int flag_go_to_next;
	int writeback_LDI;
	int writeback_LD_LDR;
	int writeback_STI;
	int flag_writeback;
	
function new(virtual dut_Probe_CON C_int);
begin
	this.C_int = C_int;
	this.flag_reset = 0;
	this.flag_LDI=0;
	this.flag_LD_LDR=0;
	this.flag_STI=0;
	this.flag_ST_STR=0;
	this.flag_br_taken=0;
	this.flag_br_taken_LD_LDR=0;
	this.flag_br_taken_LDI=0;
	this.flag_br_taken_ST_STR=0;
	this.flag_br_taken_STI=0;
	this.flag_br_taken_LD_LDR_st1=0;
	this.flag_br_taken_LDI_st1=0;
	this.flag_br_taken_ST_STR_st1=0;
	this.flag_br_taken_STI_st1=0;
	this.branch_nottaken=0;
	this.flag_go_to_next=0;
	this.writeback_LDI=0;
	this.writeback_LD_LDR=0;
	this.writeback_STI=0;
end
endfunction:new

	
task run();
forever
		begin
			@(posedge C_int.control_clk);
			#2
			//$display($time,"%d",C_int.control_reset);
			C_int.mycontrol_bypass_alu_1 = 0;
			C_int.mycontrol_bypass_alu_2 = 0;
			C_int.mycontrol_bypass_mem_1 = 0;
			C_int.mycontrol_bypass_mem_2 = 0;
			
			
			if(C_int.control_reset == 1 && flag_reset == 0)
			begin
				//$display($time,"inside reset if");
				C_int.mycontrol_enable_updatePC = 0;
				C_int.mycontrol_enable_fetch = 0;
				C_int.mycontrol_enable_decode = 0;
				C_int.mycontrol_enable_execute = 0;
				C_int.mycontrol_enable_writeback = 0;
				C_int.mycontrol_bypass_alu_1 = 0;
				C_int.mycontrol_bypass_alu_2 = 0;
				C_int.mycontrol_bypass_mem_1 = 0;
				C_int.mycontrol_bypass_mem_2 = 0;
				//C_int.mycontrol_br_taken = 0;
				C_int.mycontrol_mem_state = 3;
				@(posedge C_int.control_clk);
				C_int.mycontrol_enable_fetch = 1;
				C_int.mycontrol_br_taken = 0;
				flag_reset = 2;
			end
			else
			begin
				
				if(flag_reset == 1)
				begin
					flag_reset = 2;
				end
				else if(flag_reset == 2)
				begin
					
					
					flag_reset = 3;
				end
				else if(flag_reset == 3)
				begin
					C_int.mycontrol_enable_updatePC = 1;
					
					flag_reset = 4;
				end
				else if(flag_reset == 4)
				begin
					C_int.mycontrol_enable_decode = 1;
					flag_reset = 5;
				end
				else if(flag_reset == 5)
				begin
					C_int.mycontrol_enable_execute = 1;
					flag_reset = 6;
				end
				else if(flag_reset ==6)
				begin
					C_int.mycontrol_enable_writeback = 1;
					flag_reset = 0;
				end
				
				//ALU bypass
				if((C_int.control_IR_Exec[15:12] == 4'b0001) ||
				   (C_int.control_IR_Exec[15:12] == 4'b0101) ||
				   (C_int.control_IR_Exec[15:12] == 4'b1001) ||
				   (C_int.control_IR_Exec[15:12] == 4'b1110))
				begin
					
					//ALU Bypass for source 1
					if(
						((C_int.control_IR[15:12] == 4'b0001) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  || 
						((C_int.control_IR[15:12] == 4'b0101) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  ||
						((C_int.control_IR[15:12] == 4'b0110) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  ||
						((C_int.control_IR[15:12] == 4'b0111) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  ||
						((C_int.control_IR[15:12] == 4'b1001) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  ||
						((C_int.control_IR[15:12] == 4'b1100) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))
					   )
					begin
						C_int.mycontrol_bypass_alu_1 = 1;
					end 
					else
					begin
						C_int.mycontrol_bypass_alu_1 = 0;
					end
				
					//ALU Bypass for source 2
					if(
						((C_int.control_IR[15:12] == 4'b0001) && (C_int.control_IR[5] == 0)) ||
						((C_int.control_IR[15:12] == 4'b0101) && (C_int.control_IR[5] == 0))
					  )
					begin
						if(C_int.control_IR_Exec[11:9] == C_int.control_IR[2:0])
						begin
							C_int.mycontrol_bypass_alu_2 = 1;
						end	
						else
						begin
							C_int.mycontrol_bypass_alu_2 = 0;
						end
					end
					else if(
						((C_int.control_IR[15:12] == 4'b0111) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[11:9])) ||
						((C_int.control_IR[15:12] == 4'b1011) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[11:9])) ||
						((C_int.control_IR[15:12] == 4'b0011) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[11:9]))
					  )
					begin
						C_int.mycontrol_bypass_alu_2 = 1;
					end
					else
					begin
						C_int.mycontrol_bypass_alu_2 = 0;
					end
				end
				
				//Mem bypass
				if(
					(C_int.control_IR_Exec[15:12] == 4'b0010) ||
					(C_int.control_IR_Exec[15:12] == 4'b0110) ||
					(C_int.control_IR_Exec[15:12] == 4'b1010)
				   )
				begin
					
					//Mem Bypass for source 1
					if(
						((C_int.control_IR[15:12] == 4'b0001) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  || 
						((C_int.control_IR[15:12] == 4'b0101) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  ||
						((C_int.control_IR[15:12] == 4'b1001) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))  ||
						((C_int.control_IR[15:12] == 4'b1100) && (C_int.control_IR_Exec[11:9] == C_int.control_IR[8:6]))
					   )
					begin
						C_int.mycontrol_bypass_mem_1 = 1;
					end 
					else
					begin
						C_int.mycontrol_bypass_mem_1 = 0;
					end
				
					//Mem Bypass for source 2
					if(
						((C_int.control_IR[15:12] == 4'b0001) && (C_int.control_IR[5] == 0))||
						((C_int.control_IR[15:12] == 4'b0101) && (C_int.control_IR[5] == 0))
					  )
					begin
						if(C_int.control_IR_Exec[11:9] == C_int.control_IR[2:0])
						begin
							C_int.mycontrol_bypass_mem_2 = 1;
						end	
						else
						begin
							C_int.mycontrol_bypass_mem_2 = 0;
						end
					end		
				end
				
				
				//Mem_state output
				if(C_int.mycontrol_mem_state == 0)
					C_int.mycontrol_mem_state = 2'b11;
				else if(C_int.mycontrol_mem_state == 2'b10)
					C_int.mycontrol_mem_state = 2'b11;
				else if(C_int.mycontrol_mem_state == 2'b01)
				begin
					if(C_int.control_IR_Exec[15:12] == 4'b1010)
						C_int.mycontrol_mem_state = 2'b00;
					else
						C_int.mycontrol_mem_state = 2'b10;
				end
				else if(C_int.mycontrol_mem_state == 2'b11)
				begin
					if((C_int.control_IR_Exec[15:12] == 4'b1010) || (C_int.control_IR_Exec[15:12] == 4'b1011))
						C_int.mycontrol_mem_state = 2'b01;
					else if((C_int.control_IR_Exec[15:12] == 4'b0010) || (C_int.control_IR_Exec[15:12] == 4'b0110))
						C_int.mycontrol_mem_state = 2'b00;
					else if((C_int.control_IR_Exec[15:12] == 4'b0111) || (C_int.control_IR_Exec[15:12] == 4'b0011))
						C_int.mycontrol_mem_state = 2'b10;
					else
						C_int.mycontrol_mem_state = 2'b11;
				end
				
				
				
				
				//enable signals
				
				//enable for LD and LDR		
				if(((C_int.control_IR_Exec[15:12] == 4'b0010) || (C_int.control_IR_Exec[15:12] == 4'b0110)) && flag_LD_LDR == 0)
				begin
					C_int.mycontrol_enable_updatePC = 0;
					C_int.mycontrol_enable_fetch = 0;
					C_int.mycontrol_enable_decode = 0;
					C_int.mycontrol_enable_execute = 0;
					C_int.mycontrol_enable_writeback = 0;
					flag_LD_LDR = 1;
				end
				else if(flag_LD_LDR == 1)
				begin
					C_int.mycontrol_enable_updatePC = 1;
					C_int.mycontrol_enable_fetch = 1;
					C_int.mycontrol_enable_decode = 1;
					C_int.mycontrol_enable_execute = 1;
					C_int.mycontrol_enable_writeback = 1;
					//$display($time,"Here making 1 because of LDR");
					
					flag_LD_LDR = 0;
				end
				
				
				//enable for LDI		
				if(C_int.control_IR_Exec[15:12] == 4'b1010 && flag_LDI == 0)
				begin
					C_int.mycontrol_enable_updatePC = 0;
					C_int.mycontrol_enable_fetch = 0;
					C_int.mycontrol_enable_decode = 0;
					C_int.mycontrol_enable_execute = 0;
					C_int.mycontrol_enable_writeback = 0;
					
					flag_LDI = 1;
				end
				else if(flag_LDI == 1)
				begin			
					flag_LDI = 2;
				end
				else if(flag_LDI == 2)
				begin
					flag_LDI = 0;
					
					C_int.mycontrol_enable_updatePC = 1;
					C_int.mycontrol_enable_fetch = 1;
					C_int.mycontrol_enable_decode = 1;
					C_int.mycontrol_enable_execute = 1;
					C_int.mycontrol_enable_writeback = 1;
				end
				
				//enable for ST, STR
				if(((C_int.control_IR_Exec[15:12] == 4'b0011) || (C_int.control_IR_Exec[15:12] == 4'b0111)) && flag_ST_STR == 0)
				begin
					C_int.mycontrol_enable_updatePC = 0;
					C_int.mycontrol_enable_fetch = 0;
					C_int.mycontrol_enable_decode = 0;
					C_int.mycontrol_enable_execute = 0;
					C_int.mycontrol_enable_writeback = 0;
					
					flag_ST_STR = 1;
				end
				else if(flag_ST_STR == 1)
				begin
					C_int.mycontrol_enable_updatePC = 1;
					C_int.mycontrol_enable_fetch = 1;
					C_int.mycontrol_enable_decode = 1;
					C_int.mycontrol_enable_execute = 1;
					
					flag_ST_STR = 2;
				end
				else if(flag_ST_STR == 2)
				begin
					C_int.mycontrol_enable_writeback = 1;
					flag_ST_STR = 0;
				end
				
				//enable for STI
				if(C_int.control_IR_Exec[15:12] == 4'b1011 && flag_STI == 0)
				begin
					C_int.mycontrol_enable_updatePC = 0;
					C_int.mycontrol_enable_fetch = 0;
					C_int.mycontrol_enable_decode = 0;
					C_int.mycontrol_enable_execute = 0;
					C_int.mycontrol_enable_writeback = 0;
					
					flag_STI = 1;
				end
				else if(flag_STI == 1)
				begin
					flag_STI = 2;
				end
				else if(flag_STI == 2)
				begin
					flag_STI = 3;
					
					C_int.mycontrol_enable_updatePC = 1;
					C_int.mycontrol_enable_fetch = 1;
					C_int.mycontrol_enable_decode = 1;
					C_int.mycontrol_enable_execute = 1;
				end
				else if(flag_STI == 3)
				begin
					flag_STI = 0;
					C_int.mycontrol_enable_writeback = 1;
				end
				
				//enable for br_taken
				#1;
				
				C_int.mycontrol_br_taken = |(C_int.control_NZP & C_int.control_PSR);
				
				if(((C_int.control_IMem_dout[15:12] == 4'b0000) || (C_int.control_IMem_dout[15:12] == 4'b1100)) && flag_br_taken == 0)
				begin
					
					/*------------------------------------------
						For all mem in IR
					-------------------------------------------*/
					flag_st1 = 0;
					
					if(((C_int.control_IR_Exec[15:12] == 4'b0010) || (C_int.control_IR_Exec[15:12] == 4'b0110)) && flag_br_taken_LD_LDR_st1 == 0)
					begin	
						flag_br_taken_LD_LDR_st1 = 1;
						flag_st1 = 1;
					end
					else if(flag_br_taken_LD_LDR_st1 == 1)
					begin
						C_int.mycontrol_enable_updatePC = 0;
						C_int.mycontrol_enable_fetch = 0;
						flag_br_taken_LD_LDR_st1 = 0;
						
						flag_st1 = 1;
						//$display($time,"hello from State 1--->state 1");
						flag_br_taken = 1;
					end
					
					if((C_int.control_IR_Exec[15:12] == 4'b1010) && flag_br_taken_LDI_st1 == 0)
					begin	
						flag_br_taken_LDI_st1 = 1;
						flag_st1 = 1;
					end
					else if(flag_br_taken_LDI_st1 == 1)
					begin
						flag_br_taken_LDI_st1 = 2;
						flag_st1 = 1; 
					end
					else if(flag_br_taken_LDI_st1 == 2)
					begin
						C_int.mycontrol_enable_updatePC = 0;
						C_int.mycontrol_enable_fetch = 0;
						flag_br_taken_LDI_st1 = 0;
						
						flag_st1 = 1;
						
						flag_br_taken = 1;
					end
					
					if(((C_int.control_IR_Exec[15:12] == 4'b0011) || (C_int.control_IR_Exec[15:12] == 4'b0111)) && flag_br_taken_ST_STR_st1 == 0)
					begin	
						flag_br_taken_ST_STR_st1 = 1;
						flag_st1 = 1;
					end
					else if(flag_br_taken_ST_STR_st1 == 1)
					begin
						C_int.mycontrol_enable_updatePC = 0;
						C_int.mycontrol_enable_fetch = 0;
						flag_br_taken_ST_STR_st1 = 0;
						
						flag_st1 = 1;
						
						flag_br_taken = 1;
					end
					
					if((C_int.control_IR_Exec[15:12] == 4'b1011) && flag_br_taken_STI_st1 == 0)
					begin	
						flag_br_taken_STI_st1 = 1;
						flag_st1 = 1;
					end
					else if(flag_br_taken_STI_st1 == 1)
					begin
						flag_br_taken_STI_st1 = 2;
						flag_st1 = 1;
					end
					else if(flag_br_taken_STI_st1 == 2)
					begin
						C_int.mycontrol_enable_updatePC = 0;
						C_int.mycontrol_enable_fetch = 0;
						flag_br_taken_STI_st1 = 0;
						
						flag_st1 = 1;
						
						flag_br_taken = 1;
					end
					
					
					if(flag_st1 == 0)
					begin
						C_int.mycontrol_enable_updatePC = 0;
						C_int.mycontrol_enable_fetch = 0;
						//$display($time,"Y not maiking 0");
						flag_st1 = 0;
						
						flag_br_taken = 1;
					end
					
				end
				else if(flag_br_taken == 1)
				begin
					flag_next = 0;
					C_int.mycontrol_enable_updatePC = 0;
					C_int.mycontrol_enable_fetch = 0;
					//$display($time,"Here making 0 because of br_taken state = 1");

					/*if(!((C_int.control_IR_Exec[15:12] == 4'b1011) ||  || (C_int.control_IR_Exec[15:12] == 4'b0111) ||
						 ())
							begin		
								$display($time,"inside if");
								flag_br_taken = 2;
							end*/
					
					/*------------------------------------------
						For all mem in IR_Exec
					-------------------------------------------*/
					
					if(((C_int.control_IR_Exec[15:12] == 4'b0010) || (C_int.control_IR_Exec[15:12] == 4'b0110)) && flag_br_taken_LD_LDR == 0)
					begin	
						flag_br_taken_LD_LDR = 1;
						flag_next = 1;
						//$display($time,"inside LDR if state 0");
					end
					else if(flag_br_taken_LD_LDR == 1)
					begin
						//$display($time,"inside LDR if state 1");
						C_int.mycontrol_enable_decode = 0;
						flag_br_taken_LD_LDR = 0;
						flag_br_taken = 2;
						flag_next = 1;
					end
					
					if((C_int.control_IR_Exec[15:12] == 4'b1010) && flag_br_taken_LDI == 0)
					begin
						flag_br_taken_LDI = 1;
						flag_next = 1;
					end
					else if(flag_br_taken_LDI == 1)
					begin	
						flag_br_taken_LDI = 2;
						flag_next = 1;
					end
					else if(flag_br_taken_LDI == 2)
					begin
						C_int.mycontrol_enable_decode = 0;
						flag_br_taken_LDI = 0;
						flag_br_taken = 2;
						flag_next = 1;
					end
					
					if(((C_int.control_IR_Exec[15:12] == 4'b0011) || (C_int.control_IR_Exec[15:12] == 4'b0111)) && flag_br_taken_ST_STR == 0)
					begin					
						flag_br_taken_ST_STR = 1;
						flag_next = 1;
					end
					else if(flag_br_taken_ST_STR == 1)
					begin
						flag_br_taken_ST_STR = 0;
						flag_br_taken = 2;
						C_int.mycontrol_enable_decode = 0;
						flag_next = 1;
					end
					
					if((C_int.control_IR_Exec[15:12] == 4'b1011) && flag_br_taken_STI == 0)
					begin
						flag_br_taken_STI = 1;
						flag_next = 1;
					end
					else if(flag_br_taken_STI == 1)
					begin
						flag_br_taken_STI = 2;
						flag_next = 1;
					end
					else if(flag_br_taken_STI == 2)
					begin
						flag_br_taken_STI = 0;
						flag_br_taken = 2;
						C_int.mycontrol_enable_decode = 0;	
						flag_next = 1;
					end
					
					
					/*if(C_int.mycontrol_enable_decode !== 0)
					begin
						C_int.mycontrol_enable_decode = 0;
						flag_br_taken = 2;
					end*/
				
					if(flag_next == 0)
					begin
						//$display($time,"Decode made 0 here");
						C_int.mycontrol_enable_decode = 0;
						flag_br_taken = 2;
					end
					
					
				end
				else if(flag_br_taken == 2)
				begin
					flag_br_taken = 3;
					C_int.mycontrol_enable_execute = 0;
					C_int.mycontrol_enable_writeback = 0;
					//$display($time,"Here making 0 because of br_taken state = 2");
					if(((C_int.control_IR_Exec[15:12] == 4'b0000) || (C_int.control_IR_Exec[15:12] == 4'b1100)) && C_int.mycontrol_br_taken == 1)
					begin
						C_int.mycontrol_enable_updatePC = 1;
						//$display($time,"Here making 1 because of br_taken");
					end
					else if(((C_int.control_IR_Exec[15:12] == 4'b0000) || (C_int.control_IR_Exec[15:12] == 4'b1100)) && C_int.mycontrol_br_taken == 0 )
					begin
						flag_go_to_next = 1;
					end
				end
				else if(flag_br_taken == 3)
				begin
					C_int.mycontrol_enable_fetch = 1;
					flag_br_taken = 4;
					if(flag_go_to_next == 1)
					begin
						C_int.mycontrol_enable_updatePC = 1;
						flag_go_to_next = 0;
					end
				end				
				else if(flag_br_taken == 4)
				begin
					C_int.mycontrol_enable_decode = 1;
					flag_br_taken = 5;
				end
				else if(flag_br_taken == 5)
				begin
					C_int.mycontrol_enable_execute = 1;
					flag_br_taken = 6;
				end
				else if(flag_br_taken == 6)
				begin
					
					flag_writeback = 0;
					if(flag_LD_LDR == 1 && writeback_LD_LDR == 0)
					begin
						flag_writeback = 1;
						writeback_LD_LDR = 1;
					end
					else if(writeback_LD_LDR == 1)
					begin
						flag_writeback = 1;
						C_int.mycontrol_enable_writeback = 1;
						writeback_LD_LDR = 0;
						flag_br_taken = 0;
					end
					
					if((flag_LDI == 1 || flag_ST_STR== 1) && writeback_LDI == 0)
					begin
						writeback_LDI = 1;
						flag_writeback = 1;
					end
					else if(writeback_LDI == 1)
					begin
						writeback_LDI = 2;
						flag_writeback = 1;
					end
					else if(writeback_LDI == 2)
					begin
						C_int.mycontrol_enable_writeback = 1;
						writeback_LDI = 0;
						flag_br_taken = 0;
						flag_writeback = 1;
					end
					
					if(flag_STI == 1 && writeback_STI == 0)
					begin
						writeback_STI = 1;
						flag_writeback = 1;
					end
					else if(writeback_STI == 1)
					begin
						writeback_STI = 2;
						flag_writeback = 1;
					end
					else if(writeback_STI == 2)
					begin
						writeback_STI = 3;
						flag_writeback = 1;
					end
					else if(writeback_STI == 3)
					begin
						C_int.mycontrol_enable_writeback = 1;
						writeback_STI = 0;
						flag_br_taken = 0;
						flag_writeback = 1;
					end
					
					if(flag_writeback == 0)
					begin
						C_int.mycontrol_enable_writeback = 1;
						writeback_STI = 0;
						flag_br_taken = 0;
					end
				end
			end		
end

endtask

task control_checker();
	forever
	begin
	
		@(negedge C_int.control_clk);
		if(C_int.mycontrol_enable_updatePC !== C_int.control_enable_updatePC)
			$display($time,"Control's enable update PC not same, Mine = %h, DUT = %h",C_int.mycontrol_enable_updatePC,C_int.control_enable_updatePC);
			
		if(C_int.mycontrol_enable_fetch !== C_int.control_enable_fetch)
			$display($time,"Control's enable fetch not same Mine = %h, DUT = %h",C_int.mycontrol_enable_fetch,C_int.control_enable_fetch);
			
		if(C_int.mycontrol_enable_decode !== C_int.control_enable_decode)
			$display($time,"Control's enable decode PC not same Mine = %h, DUT = %h", C_int.mycontrol_enable_decode, C_int.control_enable_decode);
			
		if(C_int.mycontrol_enable_execute !== C_int.control_enable_execute)
			$display($time,"Control's enable execute PC not same Mine = %h, DUT = %h", C_int.mycontrol_enable_execute, C_int.control_enable_execute);
			
		if(C_int.mycontrol_enable_writeback !== C_int.control_enable_writeback)
			$display($time,"Control's enable writeback PC not same Mine = %h, DUT = %h", C_int.mycontrol_enable_writeback, C_int.control_enable_writeback);
			
		if(C_int.mycontrol_br_taken !== C_int.control_br_taken)
			$display($time,"Control's enable br_taken PC not same Mine = %h, DUT = %h",C_int.mycontrol_br_taken,C_int.control_br_taken);
			
		if(C_int.mycontrol_mem_state !== C_int.control_mem_state)
			$display($time,"Control's enable mem_state PC not same Mine = %h, DUT = %h", C_int.mycontrol_mem_state, C_int.control_mem_state);
			
		if(C_int.mycontrol_bypass_alu_1 !== C_int.control_bypass_alu_1)
			$display($time,"Control's enable bypass_alu_1 PC not same Mine = %h, DUT = %h", C_int.mycontrol_bypass_alu_1, C_int.control_bypass_alu_1);
		
		if(C_int.mycontrol_bypass_alu_2 !== C_int.control_bypass_alu_2)
			$display($time,"Control's enable bypass_alu_2 PC not same Mine = %h, DUT = %h",C_int.mycontrol_bypass_alu_2,C_int.control_bypass_alu_2);
		
		if(C_int.mycontrol_bypass_mem_1 !== C_int.control_bypass_mem_1)
			$display($time,"Control's enable bypass_mem_1 PC not same Mine = %h, DUT = %h", C_int.mycontrol_bypass_mem_1, C_int.control_bypass_mem_1);
		
		if(C_int.mycontrol_bypass_mem_2 !== C_int.control_bypass_mem_2)
			$display($time,"Control's enable bypass_mem_2 PC not same Mine = %h, DUT = %h", C_int.mycontrol_bypass_mem_2, C_int.control_bypass_mem_2);
	end	
endtask: control_checker

endclass: goldenref_control
