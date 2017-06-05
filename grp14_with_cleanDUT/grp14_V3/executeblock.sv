
`include "param_mod.sv"
class goldenref_execute;
virtual dut_Probe_Exec dut_exec;

 //internal signals
 logic [3:0] internal_execute_opcode;
 //logic [15:0] dut_exec.internal_execute_alu1;
 //logic [15:0] dut_exec.internal_execute_alu2;
 logic [1:0] internal_execute_pcselect1;
 logic internal_execute_pcselect2;
 logic [15:0] internal_execute_imm5;
 logic [15:0] internal_execute_offset6;
 logic [15:0] internal_execute_offset9;
 logic [15:0] internal_execute_offset11;
 logic [15:0] internal_execute_pcout1;
 logic [15:0] internal_execute_pcout2;
 logic [15:0] mdata_int;
	
 int flag_aluout;
 
function new(virtual dut_Probe_Exec dut_exec);
this.dut_exec=dut_exec;
this.flag_aluout = 0;
endfunction
 
 task run();
	fork
		/*begin
			forever 
			begin		
				//@(posedge dut_exec.execute_clk);
				//#1
				if(dut_exec.execute_reset) //reset = 1
				begin
					dut_exec.goldenref_sr1=3'b0;
					dut_exec.goldenref_sr2=3'b0;
				end
				else  // reset = 0
				begin
					dut_exec.goldenref_sr1 = dut_exec.execute_IR[8:6];
						if(dut_exec.execute_IR[15:12] == ADDX || dut_exec.execute_IR[15:12] == ANDX || dut_exec.execute_IR[15:12] == NOTX )
						begin
						dut_exec.goldenref_sr2 = dut_exec.execute_IR[2:0];
						//$display($time, "inside ALU");
						end
						else if(dut_exec.execute_IR[15:12] == STX || dut_exec.execute_IR[15:12] == STRX || dut_exec.execute_IR[15:12] == STIX)
							dut_exec.goldenref_sr2 = dut_exec.execute_IR[11:9];
						else 
							dut_exec.goldenref_sr2 = 3'b0;
									
				end
							
			end
		end*/

		begin
			forever 
			begin	
				@(posedge dut_exec.execute_clk);
				#1
				if(dut_exec.execute_reset) //reset = 1
				begin
					dut_exec.goldenref_NZP=3'b0;
					@(posedge dut_exec.execute_clk);
					//#1
					dut_exec.goldenref_sr1=3'b0;
					dut_exec.goldenref_sr2=3'b0;
					
				end
				else  // reset = 0
				begin
					dut_exec.goldenref_sr1 = dut_exec.execute_IR[8:6];
						if(dut_exec.execute_IR[15:12] == ADDX || dut_exec.execute_IR[15:12] == ANDX || dut_exec.execute_IR[15:12] == NOTX )
						begin
						dut_exec.goldenref_sr2 = dut_exec.execute_IR[2:0];
						//$display($time, "inside ALU");
						end
						else if(dut_exec.execute_IR[15:12] == STX || dut_exec.execute_IR[15:12] == STRX || dut_exec.execute_IR[15:12] == STIX)
							dut_exec.goldenref_sr2 = dut_exec.execute_IR[11:9];
						else 
							dut_exec.goldenref_sr2 = 3'b0;
									
				end
	
				
				#5
				if(dut_exec.execute_reset) // reset = 1
					begin
						dut_exec.goldenref_W_Control_out=2'b0;
						dut_exec.goldenref_Mem_Control_out=1'b0;
						dut_exec.goldenref_aluout=16'b0;
						dut_exec.goldenref_pcout=16'b0;
						dut_exec.goldenref_dr=3'b0;
						dut_exec.goldenref_IR_Exec=16'b0;
						dut_exec.goldenref_NZP=3'b0;
						dut_exec.goldenref_M_Data =16'b0;
						dut_exec.internal_execute_alu1 =16'b0;
						dut_exec.internal_execute_alu2 =16'b0;
						internal_execute_imm5 =16'b0;
						internal_execute_offset6 =16'b0;
						internal_execute_offset9 =16'b0;
						internal_execute_offset11 =16'b0;
						internal_execute_pcout1 =16'b0;
						internal_execute_pcout2 =16'b0;
					end
				else // reset = 0
					begin
						internal_execute_imm5 = {{11{dut_exec.execute_IR[4]}},dut_exec.execute_IR[4:0]};
						internal_execute_offset6 = {{10{dut_exec.execute_IR[5]}},dut_exec.execute_IR[5:0]};
						internal_execute_offset9 = {{7{dut_exec.execute_IR[8]}},dut_exec.execute_IR[8:0]};
						internal_execute_offset11 = {{5{dut_exec.execute_IR[10]}},dut_exec.execute_IR[10:0]};
						internal_execute_pcselect1 = dut_exec.execute_E_control[3:2];
						internal_execute_pcselect2 = dut_exec.execute_E_control[1];
						internal_execute_opcode = dut_exec.execute_IR[15:12];
	
//PCOUT1
	
					case (internal_execute_pcselect1)
					2'b00:internal_execute_pcout1 = internal_execute_offset11;
					2'b01:internal_execute_pcout1 = internal_execute_offset9;
					2'b10:internal_execute_pcout1 = internal_execute_offset6;
					2'b11:internal_execute_pcout1 = 0;
					endcase
	
//PCOUT2 

					if (internal_execute_pcselect2)
						internal_execute_pcout2 = dut_exec.execute_npc_in - 1; 
					else
						begin
							if(dut_exec.execute_bypass_mem_1)
								internal_execute_pcout2 = dut_exec.execute_Mem_Bypass_Val;
							else if(dut_exec.execute_bypass_alu_1)
								internal_execute_pcout2 = dut_exec.goldenref_aluout;
							else
								internal_execute_pcout2 = dut_exec.execute_VSR1;
						end
	      
//ALUIN1
					if(dut_exec.execute_bypass_mem_1)
						dut_exec.internal_execute_alu1 = dut_exec.execute_Mem_Bypass_Val;
					else if(dut_exec.execute_bypass_alu_1)
						dut_exec.internal_execute_alu1 = dut_exec.goldenref_aluout;
					else
						dut_exec.internal_execute_alu1 = dut_exec.execute_VSR1;
            
//ALUIN2
					if(dut_exec.execute_E_control[0] == 1'b0)
						dut_exec.internal_execute_alu2 = internal_execute_imm5;
					else
						begin
							if(dut_exec.execute_bypass_mem_2)
								dut_exec.internal_execute_alu2 = dut_exec.execute_Mem_Bypass_Val;
							else if(dut_exec.execute_bypass_alu_2)
								dut_exec.internal_execute_alu2 = dut_exec.goldenref_aluout;
							else
								dut_exec.internal_execute_alu2 = dut_exec.execute_VSR2;
						end
//MData		

						if(dut_exec.execute_enable_execute && dut_exec.execute_bypass_alu_2)
						begin 
							flag_aluout = 1;
							dut_exec.goldenref_M_Data = dut_exec.goldenref_aluout;					
						end
						/*else if(flag_aluout == 1)
						begin
							flag_aluout = 0;
							dut_exec.goldenref_M_Data = mdata_int;
						end*/	
						
						if(dut_exec.execute_enable_execute && !dut_exec.execute_bypass_alu_2)
							dut_exec.goldenref_M_Data = dut_exec.execute_VSR2;


//Synchronous signals
					if(dut_exec.execute_enable_execute) // enable = 1
					begin
						dut_exec.goldenref_W_Control_out = dut_exec.execute_W_Control_in;
						dut_exec.goldenref_Mem_Control_out = dut_exec.execute_Mem_Control_in;
						dut_exec.goldenref_IR_Exec = dut_exec.execute_IR;
		
				
						

		//ALUOUT
						case(dut_exec.execute_E_control[5:4])
							2'b00: dut_exec.goldenref_aluout = dut_exec.internal_execute_alu1+dut_exec.internal_execute_alu2;
							2'b01: dut_exec.goldenref_aluout = dut_exec.internal_execute_alu1&dut_exec.internal_execute_alu2;
							2'b10: dut_exec.goldenref_aluout = ~(dut_exec.internal_execute_alu1);
						endcase
		
						dut_exec.goldenref_pcout = internal_execute_pcout1+internal_execute_pcout2;
			
						if(internal_execute_opcode == ADDX || internal_execute_opcode == ANDX || internal_execute_opcode == NOTX)
							dut_exec.goldenref_pcout  =  dut_exec.goldenref_aluout;
						else
							dut_exec.goldenref_aluout =  dut_exec.goldenref_pcout;
	
		//Destination register
						if(internal_execute_opcode == ADDX || internal_execute_opcode == ANDX || internal_execute_opcode == NOTX || 
							internal_execute_opcode == LDX || internal_execute_opcode == LDRX || internal_execute_opcode == LDIX ||
							internal_execute_opcode == LEAX)
							dut_exec.goldenref_dr = dut_exec.execute_IR[11:9];		
						else
							dut_exec.goldenref_dr = 0;

		
		//NZP
						if(internal_execute_opcode == BRX)
							dut_exec.goldenref_NZP = dut_exec.execute_IR[11:9];
						else if(internal_execute_opcode == JMPX)
							dut_exec.goldenref_NZP = 3'b111;
						else
							dut_exec.goldenref_NZP = 0;
					end
					else  // enable = 0
						begin
						dut_exec.goldenref_W_Control_out = dut_exec.goldenref_W_Control_out;
						dut_exec.goldenref_Mem_Control_out = dut_exec.goldenref_Mem_Control_out;
						dut_exec.goldenref_IR_Exec = dut_exec.goldenref_IR_Exec;
						dut_exec.goldenref_dr = dut_exec.goldenref_dr;
						dut_exec.goldenref_NZP = 0;
						dut_exec.goldenref_pcout = dut_exec.goldenref_pcout;
						dut_exec.goldenref_aluout = dut_exec.goldenref_aluout;
						dut_exec.goldenref_M_Data  = dut_exec.goldenref_M_Data;
						end
				end
				end
		end
	join
endtask : run	
	
 
 task  checker_execute_sync();
	forever 
	begin
	@(posedge dut_exec.execute_clk);
	#1
	if(dut_exec.goldenref_W_Control_out !== dut_exec.execute_W_Control_out && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of W Control out %h and value from DUT of W Control out %h dont match", dut_exec.goldenref_W_Control_out, dut_exec.execute_W_Control_out);
	
	if(dut_exec.goldenref_Mem_Control_out !== dut_exec.execute_Mem_Control_out && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of Mem Control out %h and value from DUT of Mem Control out %h dont match", dut_exec.goldenref_Mem_Control_out, dut_exec.execute_Mem_Control_out);
	
	if(dut_exec.goldenref_aluout !== dut_exec.execute_aluout && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of ALU out %h and value from DUT of ALU out %h dont match",dut_exec.goldenref_aluout,dut_exec.execute_aluout);
		
	if(dut_exec.goldenref_pcout !== dut_exec.execute_pcout && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of PCOUT %h and value from DUT of PCOUT %h dont match",dut_exec.goldenref_pcout,dut_exec.execute_pcout);
		
	if(dut_exec.goldenref_dr !== dut_exec.execute_dr && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of Destination Register %h and value from DUT of Destination Register %h dont match",dut_exec.goldenref_dr,dut_exec.execute_dr);
		
	if(dut_exec.goldenref_IR_Exec !== dut_exec.execute_IR_Exec && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of IR EXEC %h and value from DUT of IR EXEC %h dont match",dut_exec.goldenref_IR_Exec,dut_exec.execute_IR_Exec);
		
	if(dut_exec.goldenref_NZP !== dut_exec.execute_NZP && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of NZP %h and value from DUT of NZP %h dont match",dut_exec.goldenref_NZP,dut_exec.execute_NZP);
		
	if(dut_exec.goldenref_M_Data !== dut_exec.execute_M_Data && dut_exec.execute_reset==0)
		$display($time,"In Execute stage Golden reference value of M Data %h and value from DUT of M Data %h dont match",dut_exec.goldenref_M_Data,dut_exec.execute_M_Data);
	end
	
endtask : checker_execute_sync

task checker_execute_async();
	forever 
	begin
	@(negedge dut_exec.execute_clk);
	if(dut_exec.goldenref_sr1 !== dut_exec.execute_sr1)
		$display($time,"In Execute stage Golden reference value of Source Register 1 %h and value from DUT of Source Register 1 %h dont match",dut_exec.goldenref_sr1,dut_exec.execute_sr1);
		
	if(dut_exec.goldenref_sr2 !== dut_exec.execute_sr2)
		$display($time,"In Execute stage Golden reference value of Source Register 2 %h and value from DUT of Source Register 2 %h dont match",dut_exec.goldenref_sr2,dut_exec.execute_sr2);
	end

endtask : checker_execute_async
 
 endclass:goldenref_execute


