`timescale 1ns/1ns
module ALU_tb;
    reg [2:0] opcode;
    reg [11:0] op1;
    reg [11:0] op2;
    reg clk;
    wire [11:0] result;
    ALU uut_ALU (opcode, op1, op2, result);
    initial begin
        $dumpfile ("ALU_tb.vcd");
        $dumpvars (0, ALU_tb);

        $display ("Instruction\t\tOp. Code\tOperand1\tOperand2\tResult");
        //tests for all operations
        $monitor("%b\t%b\t%b\t%b", opcode, op1, op2, result);
            opcode = 3'b000; op1=12'b000000000110; op2=12'b000000000011; clk=1; #10; clk=0; #10; //Nothing
            opcode = 3'b001; op1=12'b000000000110; op2=12'b000000000011; clk=1; #10; clk=0; #10; //Addition :: 64+1=65
            opcode = 3'b010; op1=12'b000000000110; op2=12'b000000000011; clk=1; #10; clk=0; #10; //Subtraction :: 64-1=63
            opcode = 3'b011; op1=12'b000000000110; op2=12'b000000000011; clk=1; #10; clk=0; #10; //Unsigned Multiplication :: 32*2=64
            opcode = 3'b100; op1=12'b000000000110; op2=12'b000000000110; clk=1; #10; clk=0; #10; //Signed Multiplication :: 16*(-2)=(-32)
            opcode = 3'b101; op1=12'b001111000000; op2=12'b001101100000; clk=1; #10; clk=0; #10; //Floating Addition :: 1.25+2.5=3.75  
            opcode = 3'b110; op1=12'b001111000000; op2=12'b101111000000; clk=1; #10; clk=0; #10; //Floating Multiplication :: 1.25*(-2.5)=(-3.125)
            opcode = 3'b111; op1=12'b000000000011; op2=12'b000000000001; clk=1; #10; clk=0; #10; //Comparator :: output = non zero

        #10 $display ("Test Completed");
        $finish; 
    end
endmodule