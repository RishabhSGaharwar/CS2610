`timescale 1ns/1ns

module Control_Unit (instruction, result);
	input  [18:0]instruction;						//Instruction received 
	wire   [6:0]select;							//Decoder output
	output [7:0]result;							//Final result
		
	//Implementing a Decoder
	not not1(invi0, instruction[18]);					//NOT operation on first instruction bit
	not not2(invi1, instruction[17]);					//NOT operation on second instruction bit
	not not3(invi2, instruction[16]);					//NOT operation on third instruction bit
	and and1(select[6], instruction[18], instruction[17], instruction[16]);	//Minterm for value 7	
	and and2(select[5], instruction[18], instruction[17], invi2);		//Minterm for value 6
	and and3(select[4], instruction[18], invi1, instruction[16]);		//Minterm for value 5
	and and4(select[3], instruction[18], invi1, invi2);			//Minterm for value 4
	and and5(select[2], invi0, instruction[17], instruction[16]);		//Minterm for value 3
	and and6(select[1], invi0, instruction[17], invi2);			//Minterm for value 2
	and and7(select[0], invi0, invi1, instruction[16]);			//Minterm for value 1
	
	ALU ALU_dut (.sel(select), .instruction(instruction), .out(result));	//ALU Module
	
endmodule
