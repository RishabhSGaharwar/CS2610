`timescale 1ns/1ns

module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output cout, sum;
    wire w1, w2, w3;

    and and1(w1, a, b);
    and and2(w2, a, cin);
    and and3(w3, b, cin);
    or   or1(cout, w1, w2, w3);
    xor xor1(sum, a, b, cin);
endmodule 

module ThreeToTwo(inp1, inp2, inp3, sum, carry);
  input [15:0]inp1, inp2, inp3;
  output [15:0]sum, carry;
  wire [15:0]carryt;
  FullAdder FullAdder_dut00(.a(inp1[0]), .b(inp2[0]), .cin(inp3[0]), .sum(sum[0]), .cout(carryt[0]));
  FullAdder FullAdder_dut01(.a(inp1[1]), .b(inp2[1]), .cin(inp3[1]), .sum(sum[1]), .cout(carryt[1]));
  FullAdder FullAdder_dut02(.a(inp1[2]), .b(inp2[2]), .cin(inp3[2]), .sum(sum[2]), .cout(carryt[2]));
  FullAdder FullAdder_dut03(.a(inp1[3]), .b(inp2[3]), .cin(inp3[3]), .sum(sum[3]), .cout(carryt[3]));
  FullAdder FullAdder_dut04(.a(inp1[4]), .b(inp2[4]), .cin(inp3[4]), .sum(sum[4]), .cout(carryt[4]));
  FullAdder FullAdder_dut05(.a(inp1[5]), .b(inp2[5]), .cin(inp3[5]), .sum(sum[5]), .cout(carryt[5]));
  FullAdder FullAdder_dut06(.a(inp1[6]), .b(inp2[6]), .cin(inp3[6]), .sum(sum[6]), .cout(carryt[6]));
  FullAdder FullAdder_dut07(.a(inp1[7]), .b(inp2[7]), .cin(inp3[7]), .sum(sum[7]), .cout(carryt[7]));
  FullAdder FullAdder_dut08(.a(inp1[8]), .b(inp2[8]), .cin(inp3[8]), .sum(sum[8]), .cout(carryt[8]));
  FullAdder FullAdder_dut09(.a(inp1[9]), .b(inp2[9]), .cin(inp3[9]), .sum(sum[9]), .cout(carryt[9]));
  FullAdder FullAdder_dut10(.a(inp1[10]), .b(inp2[10]), .cin(inp3[10]), .sum(sum[10]), .cout(carryt[10]));
  FullAdder FullAdder_dut11(.a(inp1[11]), .b(inp2[11]), .cin(inp3[11]), .sum(sum[11]), .cout(carryt[11]));
  FullAdder FullAdder_dut12(.a(inp1[12]), .b(inp2[12]), .cin(inp3[12]), .sum(sum[12]), .cout(carryt[12]));
  FullAdder FullAdder_dut13(.a(inp1[13]), .b(inp2[13]), .cin(inp3[13]), .sum(sum[13]), .cout(carryt[13]));
  FullAdder FullAdder_dut14(.a(inp1[14]), .b(inp2[14]), .cin(inp3[14]), .sum(sum[14]), .cout(carryt[14]));
  FullAdder FullAdder_dut15(.a(inp1[15]), .b(inp2[15]), .cin(inp3[15]), .sum(sum[15]), .cout(carryt[15]));

  assign carry[15:1]=carryt[14:0];
  assign carry[0]=1'b0;

endmodule

module CLA4h(p, g, cin, sum);
	input [3:0]p,g;
	input cin;
	wire [4:0]c;
	wire w1, w2, w3, w4;
	
	output [3:0] sum;

	buf  (c[0], cin);

	and  (w1, p[0], c[0]);
	or   (c[1], w1, g[0]);
	and  (w2, c[1], p[1]);
	or   (c[2], g[1], w2);
	and  (w3, c[2], p[2]);
	or   (c[3], g[2], w3);
	and  (w4, c[3], p[3]);
	xor  s1[3:0](sum[3:0], p[3:0], c[3:0]);

endmodule

module CLA16ht(p, g, pi, gi);
    input [3:0]p,g;
    output pi, gi;
    wire a,b,c;
    and pi1 (pi, p[0], p[1], p[2], p[3]);
    and a1 (a, p[3], p[2], p[1], g[0]);
    and a2 (b, p[3], p[2], g[1]);
    and a3 (c, p[3], g[2]);
    or gi1 (gi, a, b, c, g[3]);
endmodule

module CLA16h(a, b, cin, cout, sum);
	input [15:0]a,b;
	input cin;
	wire [15:0]p, g;
	wire [3:0]pi, gi;
	wire [4:0] ci;
	wire w1, w2, w3,w4;
	output [15:0] sum;
	output cout;
	
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

	CLA4h CLA4_dut1a (.p(p[3:0]), .g(g[3:0]), .cin(ci[0]),  .sum(sum[3:0]));
  CLA4h CLA4_dut1b (.p(p[7:4]), .g(g[7:4]), .cin(ci[1]), .sum(sum[7:4]));
  CLA4h CLA4_dut1c (.p(p[11:8]), .g(g[11:8]), .cin(ci[2]), .sum(sum[11:8]));
  CLA4h CLA4_dut1d (.p(p[15:12]), .g(g[15:12]), .cin(ci[3]), .sum(sum[15:12]));

	buf (cout, ci[4]);
endmodule

module CSAS_Multiplier(x, y, product, of);
  input [7:0] x, y;
  output [15:0]product;
  output of;
  wire w1, w2, w3, w4, bruh1, bruh2, bruh3;

  wire [15:0] sum_vec1;
  wire [15:0] sum_vec2;
  wire [15:0] sum_vec3;
  wire [15:0] sum_vec4;
  wire [15:0] sum_vec5;
  wire [15:0] sum_vec6;
  wire [15:0] carry_vec1;
  wire [15:0] carry_vec2;
  wire [15:0] carry_vec3;
  wire [15:0] carry_vec4;
  wire [15:0] carry_vec5;
  wire [15:0] carry_vec6;
  wire [7:0] pp1;
  wire [7:0] pp2;
  wire [7:0] pp3;
  wire [7:0] pp4;
  wire [7:0] pp5;
  wire [7:0] pp6;
  wire [7:0] pp7;
  wire [7:0] pp8;
  wire [7:0] spp;
  wire [15:0] temp;
  wire [15:0] temp2, temp3;
  wire [15:0] PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8;

  and and1[7:0](pp1[7:0], x[7:0], {y[0], y[0], y[0], y[0], y[0], y[0], y[0], y[0]});
  and and2[7:0](pp2[7:0], x[7:0], {y[1], y[1], y[1], y[1], y[1], y[1], y[1], y[1]});
  and and3[7:0](pp3[7:0], x[7:0], {y[2], y[2], y[2], y[2], y[2], y[2], y[2], y[2]});
  and and4[7:0](pp4[7:0], x[7:0], {y[3], y[3], y[3], y[3], y[3], y[3], y[3], y[3]});
  and and5[7:0](pp5[7:0], x[7:0], {y[4], y[4], y[4], y[4], y[4], y[4], y[4], y[4]});
  and and6[7:0](pp6[7:0], x[7:0], {y[5], y[5], y[5], y[5], y[5], y[5], y[5], y[5]});
  and and7[7:0](pp7[7:0], x[7:0], {y[6], y[6], y[6], y[6], y[6], y[6], y[6], y[6]});
  and and8[7:0](pp8[7:0], x[7:0], {y[7], y[7], y[7], y[7], y[7], y[7], y[7], y[7]});
  xor xor1[7:0](spp[7:0], pp8[7:0], {8{y[7]}});

  assign PP1[15:8] = {8{pp1[7]}};
  assign PP1[7:0] = pp1[7:0];

  assign PP2[15:9] = {7{pp2[7]}};
  assign PP2[8:1] = pp2[7:0];
  assign PP2[0] = {1'b0};

  assign PP3[15:10] = {6{pp3[7]}};
  assign PP3[9:2] = pp3[7:0];
  assign PP3[1:0] = {2{1'b0}};

  assign PP4[15:11] = {5{pp4[7]}};
  assign PP4[10:3] = pp4[7:0];
  assign PP4[2:0] = {3{1'b0}};

  assign PP5[15:12] = {4{pp5[7]}};
  assign PP5[11:4] = pp5[7:0];
  assign PP5[3:0] = {5{1'b0}};

  assign PP6[15:13] = {3{pp6[7]}};
  assign PP6[12:5] = pp6[7:0];
  assign PP6[4:0] = {5{1'b0}};

  assign PP7[15:14] = {2{pp7[7]}};
  assign PP7[13:6] = pp7[7:0];
  assign PP7[5:0] = {6{1'b0}};

  assign PP8[15] = spp[7];
  assign PP8[14:0] = temp3[14:0];
  assign temp[15]=pp8[7];
  assign temp[14:7]=pp8[7:0];
  assign temp[6:0]={7{1'b0}};
  not nota[15:0](temp2[15:0], temp[15:0]);
  CLA16h CLA16h_dut1(.a(temp2[15:0]), .b(16'b0000000000000001), .cin(1'b0), .cout(cout), .sum(PP8[15:0]));

  ThreeToTwo ThreeToTwo_dut01 (.inp1(PP1[15:0]), .inp2(PP2[15:0]), .inp3(PP3[15:0]), .sum(sum_vec1[15:0]), .carry(carry_vec1[15:0]));
  ThreeToTwo ThreeToTwo_dut02 (.inp1(PP4[15:0]), .inp2(PP5[15:0]), .inp3(PP6[15:0]), .sum(sum_vec2[15:0]), .carry(carry_vec2[15:0]));
  ThreeToTwo ThreeToTwo_dut03 (.inp1(carry_vec1[15:0]), .inp2(sum_vec1[15:0]), .inp3(carry_vec2[15:0]), .sum(sum_vec3[15:0]), .carry(carry_vec3[15:0]));
  ThreeToTwo ThreeToTwo_dut04 (.inp1(PP7[15:0]), .inp2(sum_vec2[15:0]), .inp3(PP8[15:0]), .sum(sum_vec4[15:0]), .carry(carry_vec4[15:0]));
  ThreeToTwo ThreeToTwo_dut05 (.inp1(carry_vec3[15:0]), .inp2(sum_vec3[15:0]), .inp3(carry_vec4[15:0]), .sum(sum_vec5[15:0]), .carry(carry_vec5[15:0]));
  ThreeToTwo ThreeToTwo_dut06 (.inp1(carry_vec5[15:0]), .inp2(sum_vec5[15:0]), .inp3(sum_vec4[15:0]), .sum(sum_vec6[15:0]), .carry(carry_vec6[15:0]));

  CLA16h CLA16h_dut(.a(sum_vec6[15:0]), .b(carry_vec6[15:0]), .cin(1'b0), .cout(cout), .sum(product[15:0]));
  or or11(bruh1, product[7] ,product[8], product[9], product[10], product[11], product[12], product[13], product[14], product[15]);
  and and11(bruh2, product[7] ,product[8], product[9], product[10], product[11], product[12], product[13], product[14], product[15]);
  not not1(bruh3, bruh2);
  xor xor11(w1, x[7], y[7]);
  xnor xnor1(w2, x[7], y[7]);
  and and12(w3, w2, bruh1);
  and and22(w4, bruh3, w1);
  or or1(of, w3, w4);
endmodule

