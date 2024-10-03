`timescale 1ns/1ns

module CLA4(a, b, cin, cout, sum, of);
	input [3:0]a,b;
	input cin;
	wire [4:0]c;
	wire w1, w2, w3, w4;
	wire [3:0]g,p;
	
	output [3:0] sum;
	output cout;
    output of;

	xor gateo1[3:0](p[3:0], a[3:0], b[3:0]);
	and gatea1[3:0](g[3:0], a[3:0], b[3:0]);	

	buf  (c[0], cin);
	and  (w1, p[0], c[0]);
	or   (c[1], w1, g[0]);
	and  (w2, c[1], p[1]);
	or   (c[2], g[1], w2);
	and  (w3, c[2], p[2]);
	or   (c[3], g[2], w3);
	and  (w4, c[3], p[3]);
	or   (c[4], g[3], w4);
	xor  gateo2[3:0](sum[3:0], p[3:0], c[3:0]);
	buf  (cout, c[4]);
    xor  (of, c[4], c[3]);
endmodule

module CLA16(a, b, cin, cout, sum, of);
	input [15:0]a,b;
	input cin;
	wire [16:0]c;
    wire [3:0]w1;
	output [15:0] sum;
	output cout;
	output of;

    buf (c[0], cin);

	CLA4 CLA4_dut1a (.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .cout(c[4]), .sum(sum[3:0]), .of(w1[0]));
    CLA4 CLA4_dut1b (.a(a[7:4]), .b(b[7:4]), .cin(c[4]), .cout(c[8]), .sum(sum[7:4]), .of(w1[1]));
    CLA4 CLA4_dut1c (.a(a[11:8]), .b(b[11:8]), .cin(c[8]), .cout(c[12]), .sum(sum[11:8]), .of(w1[2]));
    CLA4 CLA4_dut1d (.a(a[15:12]), .b(b[15:12]), .cin(c[12]), .cout(c[16]), .sum(sum[15:12]), .of(w1[3]));
	
	buf (cout, c[16]);
    buf (of, w1[3]);
endmodule

module Sub16(a, b, cin, cout, sum, of);
	input [15:0]a,b;
	input cin;
	wire [16:0]c;
	output [15:0] sum;
    wire [15:0]B;
	output cout;
    output of;
	
    buf (c[0], 1'b1);
    not not1[15:0](B[15:0], b[15:0]);

	CLA16 CLA16_dut1a (.a(a[15:0]), .b(B[15:0]), .cin(c[0]), .cout(c[16]), .sum(sum[15:0]), .of(of));
    
	buf (cout, c[16]);
endmodule

module AddSub(a, b, cin, A, cout, sum);
    input [15:0]a, b;
    input cin;
    input A;
    output [15:0]sum;
    wire [16:0]c1, c2;
    wire [15:0]sum1, sum3;
    wire [15:0]sum2, sum4;
    wire [15:0]bit1, bit2;
    wire w1, w2, w3;
    wire of1, of2;
    output cout;

    buf (c1[0], cin);
    buf (c2[0], cin);

    buf (bit1[0], A);
    buf (bit1[1], A);
    buf (bit1[2], A);
    buf (bit1[3], A);
    buf (bit1[4], A);
    buf (bit1[5], A);
    buf (bit1[6], A);
    buf (bit1[7], A);
    buf (bit1[8], A);
    buf (bit1[9], A);
    buf (bit1[10], A);
    buf (bit1[11], A);
    buf (bit1[12], A);
    buf (bit1[13], A);
    buf (bit1[14], A);
    buf (bit1[15], A);
    not not1[15:0](bit2[15:0], bit1[15:0]);

    CLA16 CLA16_dut (.a(a[15:0]), .b(b[15:0]), .cin(c1[0]), .cout(c1[16]), .sum(sum1[15:0]), .of(of1));
    Sub16 Sub16_dut (.a(a[15:0]), .b(b[15:0]), .cin(c2[0]), .cout(c2[16]), .sum(sum2[15:0]), .of(of2));

    not (w1, A);
    and and1[15:0](sum3[15:0], sum1[15:0], bit1[15:0]);
    and and2[15:0](sum4[15:0], sum2[15:0], bit2[15:0]);
    or   or1[15:0](sum[15:0], sum3[15:0], sum4[15:0]);
    and (w2, of1, A);
    and (w3, of2, w1);
    or  (cout, w2, w3);
endmodule