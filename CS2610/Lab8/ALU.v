`timescale 1ns/1ns

module ALU(opcode, inp1, inp2, out);
    input  [11:0] inp1, inp2;
    input  [2:0]  opcode;
    output [11:0] out;
    wire   [11:0] fout0, fout1, fout2, fout3, fout4, fout5, fout6, fout7;
    wire   [7:0]  tfout3, tfout4;
    wire   [7:0]  select;
    wire   [11:0] sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7;
    wire   [7:0] ofs;
    wire   [7:0] couts;
    wire   sign;

    not not1(invi0, opcode[2]);					//NOT operation on first instruction bit
	not not2(invi1, opcode[1]);					//NOT operation on second instruction bit
	not not3(invi2, opcode[0]);					//NOT operation on third instruction bit
	and and1(select[7], opcode[2], opcode[1], opcode[0]);	//Minterm for value 7	
	and and2(select[6], opcode[2], opcode[1], invi2);		//Minterm for value 6
	and and3(select[5], opcode[2], invi1, opcode[0]);		//Minterm for value 5
	and and4(select[4], opcode[2], invi1, invi2);			//Minterm for value 4
	and and5(select[3], invi0, opcode[1], opcode[0]);		//Minterm for value 3
	and and6(select[2], invi0, opcode[1], invi2);			//Minterm for value 2
	and and7(select[1], invi0, invi1, opcode[0]);           //Minterm for value 1
    and and8(select[0], invi0, invi1, invi2);               //Minterm for value 0

    buf buf1[11:0](fout0[11:0], {12{1'b0}});
    // buf buf3[11:0](fout4[11:0], {12{1'b0}});
    // xor xor1(sign, inp1[7], inp2[7]);
    AddSub AddSub_dut1 (.a(inp1), .b(inp2), .cin(1'b0), .A(1'b1), .cout(couts[0]), .sum(fout1));
    AddSub AddSub_dut2 (.a(inp1), .b(inp2), .cin(1'b0), .A(1'b0), .cout(couts[1]), .sum(fout2));
    CSA_Multiplier CSA_Multiplier_dut1 (.x(inp1[7:0]), .y(inp2[7:0]), .result(fout3[7:0]), .of(ofs[0]));
    CSAS_Multiplier CSAS_Multiplier_dut1 (.x(inp1[7:0]), .y(inp2[7:0]), .result(fout4[7:0]), .of(ofs[1]));
    Main_A Main_A_dut1 (inp1, inp2, fout5);
    Main_M Main_M_dut1 (inp1, inp2, fout6, ofs[2]);
    Comparator Comparator_dut1 (inp1, inp2, fout7);

    buf buf2[3:0](fout3[11:8], {4{1'b0}});
    buf buf3[3:0](fout4[11:8], {4{1'b0}});
    buf buf4[7:0](fout3[7:0], tfout3[7:0]);
    // buf buf5[7:0](fout4[7:0], tfout4[7:0]);

    and and00[11:0](sel0[11:0], fout0[11:0], {12{select[0]}});
    and and01[11:0](sel1[11:0], fout1[11:0], {12{select[1]}});
	and and02[11:0](sel2[11:0], fout2[11:0], {12{select[2]}});
	and and03[11:0](sel3[11:0], fout3[11:0], {12{select[3]}});
	and and04[11:0](sel4[11:0], fout4[11:0], {12{select[4]}});
	and and05[11:0](sel5[11:0], fout5[11:0], {12{select[5]}});
	and and06[11:0](sel6[11:0], fout6[11:0], {12{select[6]}});
	and and07[11:0](sel7[11:0], fout7[11:0], {12{select[7]}});

    or   or1[11:0](out[11:0], sel0[11:0], sel1[11:0], sel2[11:0], sel3[11:0], sel4[11:0], sel5[11:0], sel6[11:0], sel7[11:0]);
endmodule

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

module CLA12(a, b, cin, cout, sum, of);
	input [11:0]a,b;
	input cin;
	wire [12:0]c;
    wire [2:0]w1;
	output [11:0] sum;
	output cout;
	output of;

    buf (c[0], cin);

	CLA4 CLA4_dut1a (.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .cout(c[4]), .sum(sum[3:0]), .of(w1[0]));
    CLA4 CLA4_dut1b (.a(a[7:4]), .b(b[7:4]), .cin(c[4]), .cout(c[8]), .sum(sum[7:4]), .of(w1[1]));
    CLA4 CLA4_dut1c (.a(a[11:8]), .b(b[11:8]), .cin(c[8]), .cout(c[12]), .sum(sum[11:8]), .of(w1[2]));
	
	buf (cout, c[12]);
    buf (of, w1[2]);
endmodule

module Sub12(a, b, cin, cout, sum, of);
	input [11:0]a,b;
	input cin;
	wire [12:0]c;
	output [11:0] sum;
    wire [11:0]B;
	output cout;
    output of;
	
    buf (c[0], 1'b1);
    not not1[11:0](B[11:0], b[11:0]);

	CLA12 CLA12_dut1a (.a(a[11:0]), .b(B[11:0]), .cin(c[0]), .cout(c[12]), .sum(sum[11:0]), .of(of));
    
	buf (cout, c[12]);
endmodule

module AddSub(a, b, cin, A, cout, sum);
    input [11:0]a, b;
    input cin;
    input A;
    output [11:0]sum;
    wire [12:0]c1, c2;
    wire [11:0]sum1, sum3;
    wire [11:0]sum2, sum4;
    wire [11:0]bit1, bit2;
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
    not not1[11:0](bit2[11:0], bit1[11:0]);

    CLA12 CLA12_dut (.a(a[11:0]), .b(b[11:0]), .cin(c1[0]), .cout(c1[12]), .sum(sum1[11:0]), .of(of1));
    Sub12 Sub12_dut (.a(a[11:0]), .b(b[11:0]), .cin(c2[0]), .cout(c2[12]), .sum(sum2[11:0]), .of(of2));

    not (w1, A);
    and and1[11:0](sum3[11:0], sum1[11:0], bit1[11:0]);
    and and2[11:0](sum4[11:0], sum2[11:0], bit2[11:0]);
    or   or1[11:0](sum[11:0], sum3[11:0], sum4[11:0]);
    and (w2, of1, A);
    and (w3, of2, w1);
    or  (cout, w2, w3);
endmodule

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

module CSA_Multiplier(x, y, result, of);
  input [7:0] x, y;
  output [7:0] result;
  wire [15:0]product;
  output of;
  wire cin, cout;

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
  wire [15:0] PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8;

  and and1[7:0](pp1[7:0], x[7:0], {y[0], y[0], y[0], y[0], y[0], y[0], y[0], y[0]});
  and and2[7:0](pp2[7:0], x[7:0], {y[1], y[1], y[1], y[1], y[1], y[1], y[1], y[1]});
  and and3[7:0](pp3[7:0], x[7:0], {y[2], y[2], y[2], y[2], y[2], y[2], y[2], y[2]});
  and and4[7:0](pp4[7:0], x[7:0], {y[3], y[3], y[3], y[3], y[3], y[3], y[3], y[3]});
  and and5[7:0](pp5[7:0], x[7:0], {y[4], y[4], y[4], y[4], y[4], y[4], y[4], y[4]});
  and and6[7:0](pp6[7:0], x[7:0], {y[5], y[5], y[5], y[5], y[5], y[5], y[5], y[5]});
  and and7[7:0](pp7[7:0], x[7:0], {y[6], y[6], y[6], y[6], y[6], y[6], y[6], y[6]});
  and and8[7:0](pp8[7:0], x[7:0], {y[7], y[7], y[7], y[7], y[7], y[7], y[7], y[7]});
  assign PP1 = pp1<<0;
  assign PP2 = pp2<<1;
  assign PP3 = pp3<<2;
  assign PP4 = pp4<<3;
  assign PP5 = pp5<<4;
  assign PP6 = pp6<<5;
  assign PP7 = pp7<<6;
  assign PP8 = pp8<<7;

  ThreeToTwo ThreeToTwo_dut01 (.inp1(PP1[15:0]), .inp2(PP2[15:0]), .inp3(PP3[15:0]), .sum(sum_vec1[15:0]), .carry(carry_vec1[15:0]));
  ThreeToTwo ThreeToTwo_dut02 (.inp1(PP4[15:0]), .inp2(PP5[15:0]), .inp3(PP6[15:0]), .sum(sum_vec2[15:0]), .carry(carry_vec2[15:0]));
  ThreeToTwo ThreeToTwo_dut03 (.inp1(carry_vec1[15:0]), .inp2(sum_vec1[15:0]), .inp3(carry_vec2[15:0]), .sum(sum_vec3[15:0]), .carry(carry_vec3[15:0]));
  ThreeToTwo ThreeToTwo_dut04 (.inp1(PP7[15:0]), .inp2(sum_vec2[15:0]), .inp3(PP8[15:0]), .sum(sum_vec4[15:0]), .carry(carry_vec4[15:0]));
  ThreeToTwo ThreeToTwo_dut05 (.inp1(carry_vec3[15:0]), .inp2(sum_vec3[15:0]), .inp3(carry_vec4[15:0]), .sum(sum_vec5[15:0]), .carry(carry_vec5[15:0]));
  ThreeToTwo ThreeToTwo_dut06 (.inp1(carry_vec5[15:0]), .inp2(sum_vec5[15:0]), .inp3(sum_vec4[15:0]), .sum(sum_vec6[15:0]), .carry(carry_vec6[15:0]));

  CLA16h CLA16h_dut(.a(sum_vec6[15:0]), .b(carry_vec6[15:0]), .cin(1'b0), .cout(cout), .sum(product[15:0]));
  or or1(of, product[8], product[9], product[10], product[11], product[12], product[13], product[14], product[15]);
  buf buf1[7:0](result[7:0], product[7:0]);
endmodule

module CSAS_Multiplier(x, y, result, of);
  input [7:0] x, y;
  wire [15:0]product;
  output [7:0] result;
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
  buf buf1[7:0](result[7:0], product[7:0]);
endmodule

module ZsGenerator(xs, ys, zs);
    input xs, ys;
    output zs;

    xor xor1(zs, xs, ys);	
endmodule

module MUX2_7bit(x, y, s, out);
    input  [6:0]x, y;
    input  s;
    output [6:0]out;
    wire   [6:0]w1, w2;
    wire   w3;

    not not1(w3, s);
    and and1[6:0](w1[6:0],  y[6:0], {7{s}});
    and and2[6:0](w2[6:0],  x[6:0], {7{w3}});
    or   or1[6:0](out[6:0], w1[6:0], w2[6:0]);
endmodule

module CSA_Multiplier_P(x, y, product, of);
  input [7:0] x, y;
  output [15:0]product;
  output of;
  wire cin, cout;

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
  wire [15:0] PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8;

  and and1[7:0](pp1[7:0], x[7:0], {y[0], y[0], y[0], y[0], y[0], y[0], y[0], y[0]});
  and and2[7:0](pp2[7:0], x[7:0], {y[1], y[1], y[1], y[1], y[1], y[1], y[1], y[1]});
  and and3[7:0](pp3[7:0], x[7:0], {y[2], y[2], y[2], y[2], y[2], y[2], y[2], y[2]});
  and and4[7:0](pp4[7:0], x[7:0], {y[3], y[3], y[3], y[3], y[3], y[3], y[3], y[3]});
  and and5[7:0](pp5[7:0], x[7:0], {y[4], y[4], y[4], y[4], y[4], y[4], y[4], y[4]});
  and and6[7:0](pp6[7:0], x[7:0], {y[5], y[5], y[5], y[5], y[5], y[5], y[5], y[5]});
  and and7[7:0](pp7[7:0], x[7:0], {y[6], y[6], y[6], y[6], y[6], y[6], y[6], y[6]});
  and and8[7:0](pp8[7:0], x[7:0], {y[7], y[7], y[7], y[7], y[7], y[7], y[7], y[7]});
  assign PP1 = pp1<<0;
  assign PP2 = pp2<<1;
  assign PP3 = pp3<<2;
  assign PP4 = pp4<<3;
  assign PP5 = pp5<<4;
  assign PP6 = pp6<<5;
  assign PP7 = pp7<<6;
  assign PP8 = pp8<<7;

  ThreeToTwo ThreeToTwo_dut01 (.inp1(PP1[15:0]), .inp2(PP2[15:0]), .inp3(PP3[15:0]), .sum(sum_vec1[15:0]), .carry(carry_vec1[15:0]));
  ThreeToTwo ThreeToTwo_dut02 (.inp1(PP4[15:0]), .inp2(PP5[15:0]), .inp3(PP6[15:0]), .sum(sum_vec2[15:0]), .carry(carry_vec2[15:0]));
  ThreeToTwo ThreeToTwo_dut03 (.inp1(carry_vec1[15:0]), .inp2(sum_vec1[15:0]), .inp3(carry_vec2[15:0]), .sum(sum_vec3[15:0]), .carry(carry_vec3[15:0]));
  ThreeToTwo ThreeToTwo_dut04 (.inp1(PP7[15:0]), .inp2(sum_vec2[15:0]), .inp3(PP8[15:0]), .sum(sum_vec4[15:0]), .carry(carry_vec4[15:0]));
  ThreeToTwo ThreeToTwo_dut05 (.inp1(carry_vec3[15:0]), .inp2(sum_vec3[15:0]), .inp3(carry_vec4[15:0]), .sum(sum_vec5[15:0]), .carry(carry_vec5[15:0]));
  ThreeToTwo ThreeToTwo_dut06 (.inp1(carry_vec5[15:0]), .inp2(sum_vec5[15:0]), .inp3(sum_vec4[15:0]), .sum(sum_vec6[15:0]), .carry(carry_vec6[15:0]));

  CLA16h CLA16h_dut(.a(sum_vec6[15:0]), .b(carry_vec6[15:0]), .cin(1'b0), .cout(cout), .sum(product[15:0]));
  or or1(of, product[8], product[9], product[10], product[11], product[12], product[13], product[14], product[15]);

endmodule

module ZmGenerator(xm, ym, zm, pm15);
    input [6:0] xm, ym;
    output [6:0] zm;
    output pm15;
    wire [15:0]pm;
    wire of;

    wire [7:0] X, Y;
    buf buf1[6:0](X[6:0], xm[6:0]);
    buf buf2[6:0](Y[6:0], ym[6:0]);
    buf (Y[7], 1'b1);
    buf (X[7], 1'b1);

    CSA_Multiplier_P CSA_Multiplier_P_dut00(.x(X[7:0]), .y(Y[7:0]), .product(pm[15:0]), .of(of));
    MUX2_7bit MUX2_7bit_dut00(.x(pm[13:7]), .y(pm[14:8]), .s(pm[15]), .out(zm[6:0]));
    buf (pm15, pm[15]);
endmodule

module CLA8(a, b, cin, cout, sum);
    input [7:0]a, b;
    input cin;
    output [7:0]sum;
    output cout;
    wire [8:0]c;

    buf (c[0], cin);
    CLA4 CLA4_dut1a (.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .cout(c[4]), .sum(sum[3:0]));
    CLA4 CLA4_dut1b (.a(a[7:4]), .b(b[7:4]), .cin(c[4]), .cout(c[8]), .sum(sum[7:4]));
    buf (cout, c[8]);
endmodule

module sub(sum, b_out, a, b, b_in);
    output sum;
    output b_out;
    input a,b;
    input b_in;

    xor(sum,a,b,b_in);
    wire t0,t1,t2,t3;
    not(t0,a);
    and(t1,t0,b);
    and(t2,t0,b_in);
    and(t3,b,b_in);
    or(b_out,t1,t2,t3);
endmodule

module BLS5(x, y, bin, bout, diff);
    output [4:0] diff;
    output bout;
    input [4:0] x,y;
    input bin;
    wire t1,t2,t3,t4;
    sub x1(diff[0],t1,x[0],y[0],bin);
    sub x2(diff[1],t2,x[1],y[1],t1);
    sub x3(diff[2],t3,x[2],y[2],t2);
    sub x4(diff[3],t4,x[3],y[3],t3);
    sub x5(diff[4],bout,x[4],y[4],t4);
endmodule

module MUX2_4bit(x, y, s, out);
    input  [3:0]x, y;
    input  s;
    output [3:0]out;
    wire   [3:0]w1, w2;
    wire   w3;

    not not1(w3, s);
    and and1[3:0](w1[3:0],  y[3:0], {4{s}});
    and and2[3:0](w2[3:0],  x[3:0], {4{w3}});
    or   or1[3:0](out[3:0], w1[3:0], w2[3:0]);
endmodule

module MUX2_1bit(x, y, s, out);
    input  x, y;
    input  s;
    output out;
    wire   w1, w2;
    wire   w3;

    not not1(w3, s);
    and and1(w1,  y, s);
    and and2(w2,  x, w3);
    or   or1(out, w1, w2);
endmodule

module ZeGenerator(xe, ye, pm15, ze, of);
    input [3:0]xe, ye;
    input pm15;
    output [3:0]ze;
	output of;
    wire [4:0]temp;
	wire [5:0]temp2, temp3;
    
    CLA4 CLA4_dut1a(.a(xe[3:0]), .b(ye[3:0]), .cin(1'b0), .cout(temp[4]), .sum(temp[3:0]));
    BLS5 BLS5_dut1a(.x(temp[4:0]), .y(5'b00111), .bin(1'b0), .bout(temp2[5]), .diff(temp2[4:0]));
    BLS5 BLS5_dut1b(.x(temp[4:0]), .y(5'b00110), .bin(1'b0), .bout(temp3[5]), .diff(temp3[4:0]));
	MUX2_4bit MUX2_4bit_dut00(.x(temp2[3:0]), .y(temp3[3:0]), .s(pm15), .out(ze[3:0]));
	MUX2_1bit MUX2_1bit_dut00(.x(temp2[4]), .y(temp3[4]), .s(pm15), .out(of));	
endmodule

//Floating point Multiplier
module Main_M(x, y, z, of);
    input [11:0]x, y;
    output [11:0]z;
    output of;
    wire pm15;

    ZsGenerator ZsGenerator_dut00(.xs(x[11]), .ys(y[11]), .zs(z[11]));
    ZmGenerator ZmGenerator_dut00(.xm(x[6:0]), .ym(y[6:0]), .zm(z[6:0]), .pm15(pm15));
    ZeGenerator ZeGenerator_dut00(.xe(x[10:7]), .ye(y[10:7]), .pm15(pm15), .ze(z[10:7]), .of(of));
endmodule

//Floating Point Adder
module BLS4(x, y, bin, bout, diff);
	input [3:0]x, y;
	input bin;
	wire [4:0]b;
	wire w1, w2, w3, w4;
	wire [3:0]g, p, t;
	
	output [3:0] diff;
	output bout;

	not  gaten1[3:0](t[3:0], x[3:0]);
	or   gateo1[3:0](p[3:0], t[3:0], y[3:0]); //p = ~x+y
	and  gatea1[3:0](g[3:0], t[3:0], y[3:0]); //g = ~x.y	

	buf   (b[0], bin);
	and   (w1, p[0], b[0]);
	or    (b[1], w1, g[0]);
	and   (w2, b[1], p[1]);
	or    (b[2], g[1], w2);
	and   (w3, b[2], p[2]);
	or    (b[3], g[2], w3);
	and   (w4, b[3], p[3]);
	or    (b[4], g[3], w4);
	xnor  gateo2[3:0](diff[3:0], p[3:0], b[3:0]);
	buf   (bout, b[4]);
endmodule

module ExponentComparator(xe, ye, k);
	input [3:0]xe, ye;
	output [3:0]k;
    wire [4:0]b;

    buf (b[0], 1'b0);
	BLS4 BLS4_dut00(.x(xe), .y(ye), .bin(b[0]), .bout(b[4]), .diff(k));
endmodule

module Ze_Generator_A(Xe, S, Ze);
    input [3:0]Xe;
    input S;
    output [3:0]Ze;
    wire [4:0]c;
    wire [3:0]t;
    buf (c[0], 1'b0);

    CLA4 CLA4_dut00(.a(Xe), .b(4'b0001), .cin(c[0]), .cout(c[4]), .sum(t));
    MUX2_4bit MUX2_4bit_dut00(.x(Xe), .y(t), .s(S), .out(Ze));
endmodule

module Zm_Generator_A(sm, zm);
    input [8:0]sm;
    output [6:0]zm;
    wire s;
    buf (s, sm[8]);
    wire sn;
    not (sn, s);

    wire [6:0]z1;
    and aa[6:0] (z1[6:0], sm[6:0], {7{sn}});
    wire [6:0]z0;
    and aaa[6:0] (z0[6:0], sm[7:1], {7{s}});

    or ooo[6:0] (zm[6:0], z0[6:0], z1[6:0]);
endmodule

module BS_A(b, k, o);
    input [3:0]k;
    input [7:0]b;
    output [7:0]o;

    wire [3:0]kn;
    not n1[3:0](kn[3:0], k[3:0]);
    wire sl[7:0];
    and (sl[0],  kn[2], kn[1], kn[0]);
    and (sl[1],  kn[2], kn[1], k[0]);
    and (sl[2],  kn[2], k[1], kn[0]);
    and (sl[3],  kn[2], k[1], k[0]);
    and (sl[4],  k[2], kn[1], kn[0]);
    and (sl[5],  k[2], kn[1], k[0]);
    and (sl[6],  k[2], k[1], kn[0]);
    and (sl[7],  k[2], k[1], k[0]);

    wire [7:0]b1={b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0] };
    wire [7:0]b2={1'b0, b[7], b[6], b[5], b[4], b[3], b[2], b[1] };
    wire [7:0]b3={1'b0, 1'b0, b[7], b[6], b[5], b[4], b[3], b[2] };
    wire [7:0]b4={1'b0, 1'b0, 1'b0, b[7], b[6], b[5], b[4], b[3] };
    wire [7:0]b5={1'b0, 1'b0, 1'b0, 1'b0, b[7], b[6], b[5], b[4] };
    wire [7:0]b6={1'b0, 1'b0, 1'b0, 1'b0, 1'b0, b[7], b[6], b[5] };
    wire [7:0]b7={1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, b[7], b[6] };
    wire [7:0]b8={1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, b[7] };

    // wire [7:0]b1={b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7] };
    // wire [7:0]b2={b[1], b[2], b[3], b[4], b[5], b[6], b[7], 1'b0 };
    // wire [7:0]b3={b[2], b[3], b[4], b[5], b[6], b[7], 1'b0, 1'b0 };
    // wire [7:0]b4={b[3], b[4], b[5], b[6], b[7], 1'b0, 1'b0, 1'b0 };
    // wire [7:0]b5={b[4], b[5], b[6], b[7], 1'b0, 1'b0, 1'b0, 1'b0 };
    // wire [7:0]b6={b[5], b[6], b[7], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
    // wire [7:0]b7={b[6], b[7], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
    // wire [7:0]b8={b[7], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };

    wire [7:0]t1, t2, t3,  t4,  t5,  t6,  t7,  t8;

    and a1[7:0] (t1[7:0], b1[7:0], {8{sl[0]}});
    and a2[7:0] (t2[7:0], b2[7:0], {8{sl[1]}});
    and a3[7:0] (t3[7:0], b3[7:0], {8{sl[2]}});
    and a4[7:0] (t4[7:0], b4[7:0], {8{sl[3]}});
    and a5[7:0] (t5[7:0], b5[7:0], {8{sl[4]}});
    and a6[7:0] (t6[7:0], b6[7:0], {8{sl[5]}});
    and a7[7:0] (t7[7:0], b7[7:0], {8{sl[6]}});
    and a8[7:0] (t8[7:0], b8[7:0], {8{sl[7]}});

    wire [7:0]o1;
    or level1[7:0] (o1[7:0], t1[7:0],t2[7:0],t3[7:0],t4[7:0],t5[7:0],t6[7:0],t7[7:0],t8[7:0]);

    wire kkn;
    not (kkn, k[3]);

    and arghhh[7:0] (o[7:0], {8{kkn}}, o1[7:0]);
endmodule

module Sm_Generator_A(x, o, sm);
    input [7:0]x;
    input [7:0]o;
    output [8:0] sm;
    wire [8:0]c;
    buf (c[0], 1'b0);
    CLA8 CLA8_dut00(.a(x), .b(o), .cin(c[0]), .cout(c[8]), .sum(sm[7:0]));
    buf (sm[8], c[8]);
endmodule

module Main_A(x, y, z);
    input [11:0]x, y;
    output [11:0]z;

    wire[3:0] k;
    wire[7:0] xm, ym, o;
    wire[8:0] sm;

    buf buf1(xm[7], 1'b1);
    buf buf2(ym[7], 1'b1);
    buf buf3[6:0](xm[6:0], x[6:0]);
    buf buf4[6:0](ym[6:0], y[6:0]);
    buf buf5(z[11], 1'b0);

    ExponentComparator ExponentComparator_dut00(.xe(x[10:7]), .ye(y[10:7]), .k(k[3:0]));
    BS_A BS_A_dut00(.b(ym), .k(k), .o(o));
    Sm_Generator_A Sm_Generator_A_dut00(.x(xm), .o(o), .sm(sm));
    Zm_Generator_A Zm_Generator_A_dut00(.sm(sm), .zm(z[6:0]));
    Ze_Generator_A Ze_Generator_A_dut00(.Xe(x[10:7]), .S(sm[8]), .Ze(z[10:7]));
endmodule

module Comparator(input [11:0] input1, input [11:0] input2, output [11:0] result);
    xor xor1[11:0](result[11:0], input1[11:0], input2[11:0]);
endmodule