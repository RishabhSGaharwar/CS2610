`timescale 1ns/1ns

module cu_v2_tb;
	reg[18:0] instruction;
	wire[7:0] result;
	
	Control_Unit Control_Unit_dut(instruction, result);
	
	initial begin
		$dumpfile ("cu_v2_tb.vcd");
		$dumpvars (0, cu_v2_tb);				 
		instruction = 19'b0010010001100010100; #20; //Addition     00110111 = 3 7
		instruction = 19'b0100010001100010100; #20; //Subtraction  00001111 = 0 F
		instruction = 19'b0110010001100010100; #20; //Increment    00100100 = 2 4
		instruction = 19'b1000010001100010100; #20; //Decrement    00100010 = 2 2
		instruction = 19'b1010010001100010100; #20; //Bitwise AND  00000000 = 0 0
		instruction = 19'b1100010001100010100; #20; //Bitwise OR   00110111 = 3 7
		instruction = 19'b1110010001100010100; #20; //Bitwise NOT  11011100 = D C
		
		$display ("Test Completed");
		
	end

endmodule
