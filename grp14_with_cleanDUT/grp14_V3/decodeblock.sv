/*parameter ADDX = 4'b0001;
parameter ANDX = 4'b0101;
parameter NOTX = 4'b1001;
parameter LDX =  4'b0010;
parameter LDRX = 4'b0110;
parameter LDIX = 4'b1010;
parameter LEAX = 4'b1110;
parameter STX =  4'b0011;
parameter STRX = 4'b0111;
parameter STIX = 4'b1011;
parameter BRX =  4'b0000;
parameter JMPX = 4'b1100;*/

`include "param_mod.sv"
class goldenref_decode;
virtual dut_Probe_DE.DECODE dut_de;

function new(virtual dut_Probe_DE.DECODE dut_de);
this.dut_de=dut_de;
endfunction

task run();
forever begin
@dut_de.cb;
	if(dut_de.decode_reset) // Reset = 1
		begin
		dut_de.cb.goldenref_IR <= 16'h0000;
		dut_de.cb.goldenref_npc_out<=16'h0000;
		dut_de.cb.goldenref_E_control<=6'b000000;
		dut_de.cb.goldenref_W_Control<=2'b00;
		dut_de.goldenref_Mem_Control=1'b0;
		end
	else // Reset = 0
	begin
	if(dut_de.cb.decode_enable_decode) // Enable = 1
		begin
		dut_de.cb.goldenref_IR<=dut_de.cb.decode_Instr_dout;
		dut_de.cb.goldenref_npc_out<=dut_de.cb.decode_npc_in;
//WCONTROL LOGIC
		dut_de.cb.goldenref_W_Control<=2'b00;
		if(dut_de.cb.goldenref_IR[15:12]==LDX || dut_de.cb.goldenref_IR[15:12]==LDRX || dut_de.cb.goldenref_IR[15:12]==LDIX)
			dut_de.cb.goldenref_W_Control<=2'b01;
		else if(dut_de.cb.goldenref_IR[15:12]==LEAX)
			dut_de.cb.goldenref_W_Control<=2'b10;
//ECONTROL LOGIC
		dut_de.cb.goldenref_E_control<=6'b000000;
		if(dut_de.cb.goldenref_IR[15:12]== ADDX && dut_de.cb.goldenref_IR[5]==1'b0)
			dut_de.cb.goldenref_E_control<=6'b000001;
		else if (dut_de.cb.goldenref_IR[15:12]==ADDX && dut_de.cb.goldenref_IR[5]==1'b1)
			dut_de.cb.goldenref_E_control<=6'b000000;		
		else if (dut_de.cb.goldenref_IR[15:12]== ANDX && dut_de.cb.goldenref_IR[5]==1'b0)
			dut_de.cb.goldenref_E_control<=6'b010001;
		else if (dut_de.cb.goldenref_IR[15:12]==ANDX && dut_de.cb.goldenref_IR[5]==1'b1)
			dut_de.cb.goldenref_E_control<=6'b010000;
		else if (dut_de.cb.goldenref_IR[15:12]==NOTX)
			dut_de.cb.goldenref_E_control<=6'b100000;   
		else if (dut_de.cb.goldenref_IR[15:12]==BRX)
			dut_de.cb.goldenref_E_control<=6'b000110;
		else if (dut_de.cb.goldenref_IR[15:12]==JMPX)
			dut_de.cb.goldenref_E_control<=6'b001100;
		else if (dut_de.cb.goldenref_IR[15:12]==LDX)
			dut_de.cb.goldenref_E_control<=6'b000110;
		else if (dut_de.cb.goldenref_IR[15:12]==LDRX)
			dut_de.cb.goldenref_E_control<=6'b001000;
		else if (dut_de.cb.goldenref_IR[15:12]==LDIX)
			dut_de.cb.goldenref_E_control<=6'b000110;
		else if (dut_de.cb.goldenref_IR[15:12]==LEAX)
			dut_de.cb.goldenref_E_control<=6'b000110;
		else if (dut_de.cb.goldenref_IR[15:12]==STX)
			dut_de.cb.goldenref_E_control<=6'b000110;
		else if (dut_de.cb.goldenref_IR[15:12]==STRX)
			dut_de.cb.goldenref_E_control<=6'b001000;
		else if (dut_de.cb.goldenref_IR[15:12]==STIX)
			dut_de.cb.goldenref_E_control<=6'b000110;
//MEMCONTROL LOGIC
		dut_de.goldenref_Mem_Control=1'b0;
		if(dut_de.cb.goldenref_IR[15:12]==LDIX || dut_de.cb.goldenref_IR[15:12]==STIX)
			dut_de.goldenref_Mem_Control=1'b1;
		end
	else // Enable = 0
		begin
		dut_de.cb.goldenref_IR<=dut_de.cb.goldenref_IR;
		dut_de.cb.goldenref_npc_out<=dut_de.cb.goldenref_npc_out;
		dut_de.cb.goldenref_E_control<=dut_de.cb.goldenref_E_control;
		dut_de.cb.goldenref_W_Control<=dut_de.cb.goldenref_W_Control;
		dut_de.goldenref_Mem_Control=dut_de.goldenref_Mem_Control;
		end
	end	
checker_decode();
end
endtask : run

task  checker_decode();

	if(dut_de.cb.goldenref_npc_out !== dut_de.decode_npc_out && dut_de.decode_reset==0)
		$display($time,"In Decode Stage, Golden reference value of NPC out %h and Value from dut of NPC out %h are not matching", dut_de.cb.goldenref_npc_out, dut_de.decode_npc_out);

	if(dut_de.cb.goldenref_W_Control !== dut_de.decode_W_control&& dut_de.decode_reset==0)
		$display($time,"In Decode Stage, Golden reference value of WCONTROL %h and Value from dut of WCONTROL %h are not matching", dut_de.cb.goldenref_W_Control, dut_de.decode_W_control);
	
	if(dut_de.goldenref_Mem_Control !== dut_de.decode_Mem_control && dut_de.decode_reset==0)
		$display($time,"In Decode Stage, Golden reference value of MEMCONTROL %h and Value from dut of MEMCONTROL %h are not matching", dut_de.goldenref_Mem_Control, dut_de.decode_Mem_control);	
		
	if(dut_de.cb.goldenref_E_control !== dut_de.decode_E_control && dut_de.decode_reset==0)
		$display($time,"In Decode Stage, Golden reference value of ECONTROL %h and Value from dut of ECONTROL %h are not matching", dut_de.cb.goldenref_E_control, dut_de.decode_E_control);
	
   	if(dut_de.cb.goldenref_IR !== dut_de.decode_IR)//dut_de.decode_Instr_dout && dut_de.decode_reset==0)
		$display($time,"In Decode Stage, Golden reference value of IR %h and Value from dut of IR %h are not matching", dut_de.cb.goldenref_IR, dut_de.decode_IR);	
		
endtask : checker_decode

endclass:goldenref_decode













