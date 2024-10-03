`timescale 1ns/1ns

module Main_tb;
	reg [11:0]x, y;
	wire [11:0]z;
	Main_A Main_dut (.x(x), .y(y), .z(z));
	initial begin
		$dumpfile("Lab3.vcd");
		$dumpvars(0, Main_tb);
		// $display("suiiiiiiiiiiiii");
        $monitor("X=%b, Y=%b, Z=%b", x, y, z);
        	///for unsigned integers
        	x=12'b001111000000; y=12'b001101100000; #20//tc1 p1 // 2+2=4
        	x=12'b010011000000; y=12'b010001100000; #20//tc1 p2 // 4+4=8
        	
        	x=12'b010001000000; y=12'b001111000000; #20//tc2 p1 
        	x=12'b001111000000; y=12'b001101100000; #20//tc2 p2 

        	x=12'b010011000000; y=12'b010001000000; #20//tc3 
        	
        	x=12'b010111000000; y=12'b000111000000; #20//tc4 
		#10000 $finish;		
	end
	
endmodule
