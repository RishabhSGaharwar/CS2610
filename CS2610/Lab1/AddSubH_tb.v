`timescale 1ns/1ns

module CLA16_tb;
	reg [15:0]a,b;
	reg cin;
	reg A;
	wire [15:0]sum;
	wire cout;
	AddSubH AddSubH_dut (.a(a), .b(b), .cin(cin), .A(A), .cout(cout), .sum(sum));
	initial begin
		$display("16-bit CLA based on 4-bit CLAs (Based on Higher Order Terms)");
        $monitor("a=%b, b=%b, cin=%b, A = %b OF = %b, sum = %b", a, b, cin, A, cout, sum);
		a = 16'b0000000000000001; b = 16'b0000000000000001; cin = 0; A = 1; #20; 
		a = 16'b1000000000000000; b = 16'b1000000000000001; cin = 0; A = 1; #20;
		a = 16'b0100000000000000; b = 16'b0000000000000101; cin = 0; A = 0; #20;
		a = 16'b0000000000000001; b = 16'b0000000000000001; cin = 0; A = 1; #20;
        a = 16'b1000000000000000; b = 16'b1000000100000001; cin = 0; A = 1; #20;
		a = 16'b1100000000000001; b = 16'b1100000000000001; cin = 0; A = 1; #20;
        a = 16'b1000000000000001; b = 16'b1000000000000001; cin = 0; A = 1; #20;
		a = 16'b0000000000000001; b = 16'b1000000000000001; cin = 0; A = 1; #20;
		a = 16'b1000000000000001; b = 16'b0000000000000001; cin = 0; A = 0; #20;
		a = 16'b1000000000000000; b = 16'b0111111111111111; cin = 0; A = 0; #20;
		#300 $finish;		
	end
	
endmodule