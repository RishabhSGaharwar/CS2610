`timescale 1ns/1ns

module ALU_tb;
    reg [2:0] opcode;
    reg [11:0] op1;
    reg [11:0] op2;
    wire [11:0] result;
    ALU uut_ALU (opcode, op1, op2, result);
    initial begin
        $dumpfile ("ALU_tb.vcd");
        $dumpvars (0, ALU_tb);

        $display ("Instruction\t\tOp. Code\tOperand1\tOperand2\tResult");
        //tests for all operations
        opcode = 3'b000; op1=12'b000001000000; op2=12'b000000000001; #20; //Nothing
        opcode = 3'b001; op1=12'b000001000000; op2=12'b000000000001; #20; //Addition
        opcode = 3'b001; op1=12'b000001000000; op2=12'b000000000001; #20; //Subtraction
        opcode = 3'b001; op1=12'b000001000000; op2=12'b000000000001; #20; //Unsigned Multiplication
        opcode = 3'b001; op1=12'b000001000000; op2=12'b000000000001; #20; //Signed Multiplication
        opcode = 3'b001; op1=12'b000110000100; op2=12'b001100000001; #20; //Floating Addition
        opcode = 3'b001; op1=12'b000110000100; op2=12'b001100000001; #20; //Floating Multiplication
        opcode = 3'b001; op1=12'b000000000011; op2=12'b000000000001; #20; //Comparator

        #10 $display ("Test Completed");
        $finish;
    end
    always
        #19 $display("%b\t%b\t%b\t%b", opcode, op1, op2, result);
  
endmodule 