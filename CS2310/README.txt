Contents of README:
1.INTRODUCTION
2.REQUIREMENTS
3.INSTRUCTIONS

INTRODUCTION
-----------------------------------------------------------------------------------------------------------------------------------------
The folder contains all the required files which are required for CPU Simulation
In this folder there are 5 files
1.README : Text file explaining the contents of the folder
2. CU.v  : Verilog source code simulating Control Unit 
3. ALU.v : Verilog source code simulating the Arithmetic and Logic Unit.
4.CU_tb.v: Test Bench for CU.v
5.Report : A PDF report for this assignment explaining various parts of the project.

REQUIREMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
1. Icarus Verilog : Icarus Verilog is a free Verilog simulation and synthesis tool. It compiles source code written in
Verilog (IEEE-1364) into some target format. 

2. GTKWave : GTKWave is a fully featured GTK+ wave viewer for Unix, Win32, and Mac OSX which reads
LXT, LXT2, VZT, FST, and GHW files as well as standard Verilog VCD/EVCD files and allows
their viewing.

3. A basic text editor to view source codes.
-----------------------------------------------------------------------------------------------------------------------------------------
INSTRUCTIONS
1.Open terminal
2.Navigate to the folder with the files.
3.Compile the files using iverilog 
	(iverilog -o CU CU.v ALU.v CU_tb.v)
4.vvp the output file name to generate the vcd file (If the files compiled correctly, we should get "Test Completed" as 
message of the vvp command
	vvp CU
5.Check for cu_v2_tb.vcd file generated
6.Use GTKWave to check the waveforms
	gtkwave cu_v2_tb.vcd &
-----------------------------------------------------------------------------------------------------------------------------------------
