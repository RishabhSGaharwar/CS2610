`timescale 1ns/1ns

module Lab4_tb;
	reg [11:0]x,y;
	wire [11:0]z;
	wire of;
	Main Main_dut (.x(x), .y(y), .z(z), .of(of));
	initial begin
		$dumpfile("Lab4_test.vcd");
		$dumpvars(0, Lab4_tb);
        $monitor("x=%b, y=%b, z=%b, of=%b", x, y, z, of);
		x=12'b001101100000; y=12'b001111000000; #20//tca i p1
		x=12'b001101100000; y=12'b101111000000; #20//tca i p2
		
		x=12'b001101000000; y=12'b001111000000; #20//tca ii p1
		x=12'b001101000000; y=12'b101111000000; #20//tca ii p2
		
		x=12'b011101000000; y=12'b011101000000; #20//tcb i
		
		x=12'b000011000000; y=12'b000011000000; #20//tcb ii 
				
		#200 $finish;		
	end
	
endmodule
