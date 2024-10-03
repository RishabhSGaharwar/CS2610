`timescale 1ns/1ns
//Exponent Comparator as per diagram

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

module CLA4(a, b, cin, cout, sum);
	input [3:0]a,b;
	input cin;
	wire [4:0]c;
	wire w1, w2, w3, w4;
	wire [3:0]g,p;
	
	output [3:0] sum;
	output cout;

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
