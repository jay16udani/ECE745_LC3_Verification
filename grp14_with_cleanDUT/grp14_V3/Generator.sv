`ifndef GAURD_GENERATOR
`define GAURD_GENERATOR

//`include "params.sv"
`include "Instruction.sv"

class generator;
	Instruction Instr;
	mailbox #(Instruction) gen2drv;
	instr_type_e prev_Instr_type;
	instr_type_e q_prev_Instr[$] = {ALU,ALU,ALU,ALU,ALU,ALU};
	
	int flag_CTRLfound;
	int flag_MEMfound;
	
	function new(mailbox #(Instruction) mbx);
		this.gen2drv = mbx;
	endfunction : new

	task chekPrevFive_MEM();
		
		flag_MEMfound = 0;
		flag_CTRLfound = 0;
		
		for(int i=0;i<5; i= i+1)
		begin
			if(q_prev_Instr[i] == MEM)
			begin
				flag_MEMfound = 1;
				flag_CTRLfound = 1;
				break;
			end
		end
	endtask: chekPrevFive_MEM
	
	task chekPrevFive_CTRL();
		
		flag_MEMfound = 0;
		flag_CTRLfound = 0;
		
		for(int i=0;i<5; i= i+1)
		begin
			if(q_prev_Instr[i] == CTRL)
			begin
				flag_MEMfound = 1;
				flag_CTRLfound = 1;
				break;
			end
		end
	endtask: chekPrevFive_CTRL
	
	task chekPrevFive_BOTH();
		
		flag_MEMfound = 0;
		flag_CTRLfound = 0;
		
		for(int i=0;i<5; i= i+1)
		begin
			if(q_prev_Instr[i] == CTRL)
			begin
				flag_CTRLfound = 1;
				break;
			end
		end
		
		for(int i=0;i<5; i= i+1)
		begin
			if(q_prev_Instr[i] == MEM)
			begin
				flag_MEMfound = 1;
				break;
			end
		end
	endtask: chekPrevFive_BOTH
	
	/*task CheckPrevFive();
		//This function is written to insert 6 alu instr bw mem&mem and bra&bra
		for(q_prev_Instr[i]) {
			if(q_prev_Instr[i] == CTRL) begin
				flag_MEMfound = 0;
				flag_CTRLfound = 1;
				flag_NoCTRLorMEM = 0;
				break;
			end
			else if(q_prev_Instr[i] == MEM) begin
				flag_MEMfound = 1;
				flag_CTRLfound = 0;
				flag_NoCTRLorMEM = 0;
				break;
			end
			else begin
				flag_MEMfound = 0;
				flag_CTRLfound = 0;
				flag_NoCTRLorMEM = 1;
			end
		}
	endtask*/
			
	task set_constraints();
		
		if (prev_Instr_type == MEM)
		begin
			
			chekPrevFive_CTRL();
			if(flag_CTRLfound == 1)
			begin
				Instr.c_PrevIsMEM.constraint_mode(0);
				Instr.c_PrevIsCTRL.constraint_mode(0);
				Instr.c_ALU.constraint_mode(1);
			end
			else
			begin
				Instr.c_PrevIsMEM.constraint_mode(1);
				Instr.c_PrevIsCTRL.constraint_mode(0);
				Instr.c_ALU.constraint_mode(0);
			end
			
		end
		else if (prev_Instr_type == CTRL)
		begin
			chekPrevFive_MEM();
			if(flag_MEMfound == 1)
			begin
				Instr.c_PrevIsMEM.constraint_mode(0);
				Instr.c_PrevIsCTRL.constraint_mode(0);
				Instr.c_ALU.constraint_mode(1);
			end
			else
			begin
				Instr.c_PrevIsMEM.constraint_mode(0);
				Instr.c_PrevIsCTRL.constraint_mode(1);
				Instr.c_ALU.constraint_mode(0);
			end
		end
		else
		begin
			chekPrevFive_BOTH();
			if(flag_CTRLfound == 1 && flag_MEMfound == 1)
			begin
				Instr.c_PrevIsMEM.constraint_mode(0);
				Instr.c_PrevIsCTRL.constraint_mode(0);
				Instr.c_ALU.constraint_mode(1);
				//$display($time,"here scheduling ALU");
			end
			else if(flag_CTRLfound == 1 && flag_MEMfound == 0)
			begin
				Instr.c_PrevIsMEM.constraint_mode(0);
				Instr.c_PrevIsCTRL.constraint_mode(1);
				Instr.c_ALU.constraint_mode(0);
			end
			else if(flag_CTRLfound == 0 && flag_MEMfound == 1)
			begin
				Instr.c_PrevIsMEM.constraint_mode(1);
				Instr.c_PrevIsCTRL.constraint_mode(0);
				Instr.c_ALU.constraint_mode(0);
			end
			else
			begin
				Instr.c_PrevIsMEM.constraint_mode(0);
				Instr.c_PrevIsCTRL.constraint_mode(0);
				Instr.c_ALU.constraint_mode(0);
			end
		end	
	
	endtask : set_constraints

	
	/*task test();
		
		if(flag == 0)
		begin
			Instr.c_MEM.constraint_mode(1);
			flag = 1;
			$display($time,"hello from mem randomization");
		end
		else if(flag == 1)
		begin
			Instr.c_CTRL.constraint_mode(1);
			flag = 2;
		end
		else if(flag == 2)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 3;
		end
		else if(flag == 3)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 4;
		end
		else if(flag == 4)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 5;
		end
		else if(flag == 5)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 6;
		end
		else if(flag == 6)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 7;
		end
		else if(flag == 7)
		begin
			Instr.c_CTRL.constraint_mode(1);
			flag = 8;
		end
		else if(flag == 8)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 9;
		end
		else if(flag == 9)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 10;
		end
		else if(flag == 10)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 11;
		end
		else if(flag == 11)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 12;
		end
		else if(flag == 12)
		begin
			Instr.c_ALU.constraint_mode(1);
			flag = 0;
		end
		
	endtask: test*/
		
/*task set_flag();
	
	if(prev_Instr_type == MEM)
	begin
		flag_MEM = 1;
		$display($time,"hello mem flag");
	end	
	if(prev_Instr_type == CTRL)
	begin
		flag_CTRL = 1;
		$display($time,"hello ctrl flag");
	end	
endtask: set_flag*/

task run();
	forever begin
		Instr = new();
		//set_flag();
		set_constraints();
		//test();
		Instr.randomize;
		//$display($time,"===>INSTR Type",Instr.Instr_type);
		gen2drv.put(Instr);
		prev_Instr_type = Instr.Instr_type;
		q_prev_Instr.push_back(Instr.Instr_type);
		q_prev_Instr.pop_front;
		//$display("in generator");
		end
		//$display("out of generator");
		endtask : run
endclass : generator
`endif
