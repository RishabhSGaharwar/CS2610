`timescale 1ns/1ns

module CLA4h(p, g, cin, cout, sum, of);
	input [3:0]p,g;
	input cin;
	wire [4:0]c;
	wire w1, w2, w3, w4;
	
	output [3:0] sum;
	output cout;
    output of;

	buf  (c[0], cin);

	and  (w1, p[0], c[0]);
	or   (c[1], w1, g[0]);
	and  (w2, c[1], p[1]);
	or   (c[2], g[1], w2);
	and  (w3, c[2], p[2]);
	or   (c[3], g[2], w3);
	and  (w4, c[3], p[3]);
	or   (c[4], g[3], w4);
	xor  s1[3:0](sum[3:0], p[3:0], c[3:0]);
	xor  (of, c[4], c[3]);
endmodule

module CLA16ht(p, g, pi, gi);
    input [3:0]p,g;
    output pi, gi;
    wire a,b,c;
    and pi1 (pi, p[0], p[1], p[2], p[3]);
    and a1  (a, p[3], p[2], p[1], g[0]);
    and a2  (b, p[3], p[2], g[1]);
    and a3  (c, p[3], g[2]);
    or  gi1 (gi, a, b, c, g[3]);
endmodule

module CLA16h(a, b, cin, cout, sum, of);
	input [15:0]a,b;
	input cin;
	wire [15:0]p, g;
	wire [3:0]pi, gi;
	wire [4:0] ci;
	wire w1, w2, w3,w4;
	output [15:0] sum;
	output cout;
	output of;
	wire w5[3:0];
	
	buf(ci[0], cin);

    xor p1[15:0](p[15:0], a[15:0], b[15:0]);
	and g1[15:0](g[15:0], a[15:0], b[15:0]);

	CLA16ht uut1 (p[3:0], g[3:0], pi[0], gi[0]);
	CLA16ht uut2 (p[7:4], g[7:4], pi[1], gi[1]);
	CLA16ht uut3 (p[11:8], g[11:8], pi[2], gi[2]);
	CLA16ht uut4 (p[15:12], g[15:12], pi[3], gi[3]);

	and a1 (w1, pi[0], ci[0]);
	or o1 (ci[1], w1, gi[0]);
	and a2 (w2, pi[1], ci[1]);
	or o2 (ci[2], w2, gi[1]);
	and a3 (w3, pi[2], ci[2]);
	or o3 (ci[3], w3, gi[2]);
	and a4 (w4, pi[3], ci[3]);
	or o4 (ci[4], w4, gi[3]);

	CLA4h CLA4_dut1a (.p(p[3:0]), .g(g[3:0]), .cin(ci[0]),  .sum(sum[3:0]), .of(w5[0]));
    CLA4h CLA4_dut1b (.p(p[7:4]), .g(g[7:4]), .cin(ci[1]), .sum(sum[7:4]), .of(w5[1]));
    CLA4h CLA4_dut1c (.p(p[11:8]), .g(g[11:8]), .cin(ci[2]), .sum(sum[11:8]), .of(w5[2]));
    CLA4h CLA4_dut1d (.p(p[15:12]), .g(g[15:12]), .cin(ci[3]), .sum(sum[15:12]), .of(w5[3]));
	
	buf (cout, ci[4]);
	buf (of, w5[3]);
endmodule

module Sub16h(a, b, cin, cout, sum, of);
	input [15:0]a,b;
	input cin;
	wire [16:0]c;
	output [15:0] sum;
    wire [15:0]B;
	output cout;
	output of;
	
    buf (c[0], 1'b1);
    not not1[15:0](B[15:0], b[15:0]);

	CLA16h CLA16_dut1a (.a(a[15:0]), .b(B[15:0]), .cin(c[0]), .cout(c[16]), .sum(sum[15:0]), .of(of));
    
	buf (cout, c[16]);
endmodule

module AddSubH(a, b, cin, A, cout, sum);
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

    CLA16h CLA16_dut (.a(a[15:0]), .b(b[15:0]), .cin(c1[0]), .cout(c1[16]), .sum(sum1[15:0]), .of(of1));
    Sub16h Sub16_dut (.a(a[15:0]), .b(b[15:0]), .cin(c2[0]), .cout(c2[16]), .sum(sum2[15:0]), .of(of2));

    not (w1, A);
    and and1[15:0](sum3[15:0], sum1[15:0], bit1[15:0]);
    and and2[15:0](sum4[15:0], sum2[15:0], bit2[15:0]);
    or   or1[15:0](sum[15:0], sum3[15:0], sum4[15:0]);
    and (w2, of1, A);
    and (w3, of2, w1);
    or  (cout, w2, w3);
endmodule