`timescale 1ns/1ns

module ALU(sel, instruction, out);
	input [18:0]instruction;					//Instruction received by Control Unit
	input [6:0]sel;							//Selection lines received from Control Unit
	output [7:0]out;						//Output to be sent to Control Unit
	wire [8:0]out1, out2, out3, out4, out5, out6, out7;		//We find output of all operations
	wire [7:0]fout1, fout2, fout3, fout4, fout5, fout6, fout7;	//Final output for each operation after considering the select lines
	wire [7:0]sel1, sel2, sel3, sel4, sel5, sel6, sel7;		//Making buses from select line output receieved
	wire zero = 1'b0;						//Single bit with value zero
	
	RCA8      RCA8_dut (.in1(instruction[15:8]), .in2(instruction[7:0]), .cin(zero), .cout(out1[8]), .sum(out1[7:0]));	//Addition operation 
	subtract  subtract_dut  (.in1(instruction[15:8]), .in2(instruction[7:0]), .out(out2));					//Subtraction operation
	increment increment_dut (.inp(instruction[15:8]), .out(out3));								//Unit Increment
	decrement decrement_dut (.inp(instruction[15:8]), .out(out4));								//Unit Decrement
	AND       AND_dut       (.in1(instruction[15:8]), .in2(instruction[7:0]), .out(out5[7:0]));				//Bitwise AND operation
	OR	  OR_dut        (.in1(instruction[15:8]), .in2(instruction[7:0]), .out(out6[7:0]));				//Bitwise OR  operation
	NOT	  NOT_dut       (.inp(instruction[15:8]), .out(out7[7:0]));							//Bitwise NOT operation
	
	//Note that we have an option of saving the overflow bit but here we are ignoring the case of overflow. 
	//If required, overflow carry can be easily taken into consideration into output.
		
	//Now we make 8 bit buses for the select lines to determine the final output
	buf buf1[7:0](sel1, sel[0]);
	buf buf2[7:0](sel2, sel[1]);
	buf buf3[7:0](sel3, sel[2]);
	buf buf4[7:0](sel4, sel[3]);
	buf buf5[7:0](sel5, sel[4]);
	buf buf6[7:0](sel6, sel[5]);
	buf buf7[7:0](sel7, sel[6]); 
	
	//Since we can't use if-else conditions, we perform AND operation on output of every operation with it's select line value
	and and1[7:0](fout1[7:0], out1[7:0], sel1[7:0]);
	and and2[7:0](fout2[7:0], out2[7:0], sel2[7:0]);
	and and3[7:0](fout3[7:0], out3[7:0], sel3[7:0]);
	and and4[7:0](fout4[7:0], out4[7:0], sel4[7:0]);
	and and5[7:0](fout5[7:0], out5[7:0], sel5[7:0]);
	and and6[7:0](fout6[7:0], out6[7:0], sel6[7:0]);
	and and7[7:0](fout7[7:0], out7[7:0], sel7[7:0]);
	
	//Final result obtained by bitwise OR on every final output
	or   or1[7:0](out[7:0], fout1[7:0], fout2[7:0], fout3[7:0], fout4[7:0], fout5[7:0], fout6[7:0], fout7[7:0]);
	
endmodu44

module FullAdder(in1, in2, cin, cout, sum);											//Two bit Full Adder with an input carry value
	input in1, in2, cin;
	output cout, sum;
	
	xor xor1 (sum, in1, in2, cin);
	and and1 (anb, in1, in2);
	and and2 (bnc, in2, cin);
	and and3 (anc, in1, cin);
	or  or1  (cout, anb, anc, bnc);
	
endmodule	

module RCA8(in1, in2, cin, cout, sum);												//8-bit Ripple Carry Adder
	input [7:0]in1, in2;
	input cin;
	wire [8:0]c;
	assign c[0] = cin;
	output cout;
	output [7:0]sum;
	
	FullAdder FA_dut[7:0] (.in1(in1[7:0]), .in2(in2[7:0]), .cin(c[7:0]), .cout(c[8:1]), .sum(sum[7:0]));
	
	assign cout = c[8];

endmodule

module subtract(in1, in2, out);											
	input [7:0]in1,in2;
	output [8:0]out;
	wire [7:0]notin2;
	wire one = 1'b1;
	
	not not1[7:0] (notin2[7:0], in2[7:0]);
	RCA8 RCA8_uut (.in1(in1), .in2(notin2), .cin(one), .cout(out[8]), .sum(out[7:0]));	
	//Note that a - b is same as a + (~b + 1) where (~b + 1) is 2's complement of b
	
endmodule

module increment(inp, out);													
	input [7:0]inp;
	wire  [7:0]zero = 8'b00000000;
	output [8:0]out;
	wire one = 1'b1;
	
	RCA8 RCA8_dut (.in1(inp), .in2(zero), .cin(one), .cout(out[8]), .sum(out[7:0]));
	//Incrementing is same as addition with 1
	
endmodule

module decrement(inp, out);
	input [7:0]inp;
	output [8:0]out;
	wire [7:0]one = 8'b00000001;	
	
	subtract subtract_dut(.in1(inp), .in2(one), .out(out));
	//Decrementing is same as subtracting 1

endmodule

module AND(in1, in2, out);
	input  [7:0]in1, in2;
	output [7:0]out;
	
	and and1[7:0](out[7:0], in1[7:0], in2[7:0]);

endmodule

module OR(in1, in2, out);
	input [7:0]in1, in2;
	output [7:0]out;
	
	or or1[7:0](out[7:0], in1[7:0], in2[7:0]);
	
endmodule

module NOT(inp, out);
	input  [7:0]inp;
	output [7:0]out;
	
	not not1 [7:0](out[7:0], inp[7:0]);
	
endmodule
