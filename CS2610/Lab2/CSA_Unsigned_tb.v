`timescale 1ns/1ns

module CSA_Multiplier_tb;
	reg [7:0]a,b;
	reg cin;
	wire [15:0]product;
	wire of;
	CSA_Multiplier CSA_Multiplier_dut (.x(a), .y(b), .product(product), .of(of));
	initial begin
		$dumpfile("CLA.vcd");
		$dumpvars(0, CSA_Multiplier_tb);
        $monitor("X = %b, Y = %b PRODUCT = %b, OVERFLOW = %b", a, b, product, of);
        	///for unsigned integers
        	a=8'b00000101; b=8'b00000010; #20
        	a=8'b00000011; b=8'b00001010; #20        	
        	a=8'b10000001; b=8'b10000010; #20
		#100 $finish;		
	end
	
endmodule
