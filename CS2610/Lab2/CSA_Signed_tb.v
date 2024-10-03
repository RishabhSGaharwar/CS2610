`timescale 1ns/1ns

module CSAS_Multiplier_tb;
	reg [7:0]a,b;
	wire [15:0]product;
	wire of;
	CSAS_Multiplier CSAS_Multiplier_dut (.x(a), .y(b), .product(product), .of(of));
	initial begin
		$dumpfile("CSAS.vcd");
		$dumpvars(0, CSAS_Multiplier_tb);
        $monitor("X=%b, Y=%b, PRODUCT=%b, OVERFLOW=%b", a, b, product, of);
        	//for signed
		a=8'b00000101; b=8'b00000110; #20//tc2 p11 // 5*6=30
		a=8'b00000101; b=8'b11111010; #20//tc2 p11 // 5*-6=-30
		a=8'b11111011; b=8'b00000110; #20//tc2 p11 // -5*6=-30
		a=8'b11111111; b=8'b11111111; #20//tc2 p11 // -5*-6=30
		a=8'b11111110; b=8'b00010000; #20
		
		a=8'b01000101; b=8'b01000110; #20//tc2 p11 // 69*70=4830
		a=8'b01000101; b=8'b10111010; #20//tc2 p11 // 69*-70=-4830
		#100 $finish;		
	end
	
endmodule
