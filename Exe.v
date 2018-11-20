`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:38:13 11/18/2018 
// Design Name: 
// Module Name:    Exe 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Exe(
    input [15:0] RData1,
    input [15:0] RData2,
    input [15:0] Imme,
    input [3:0] R1,
    input [3:0] R2,
    output [15:0] WData,
    input [15:0] PCSrc,
    input [3:0] ALUOp,
    input [1:0] ControlB,//00 01 10 11
    output [15:0] ALURes,
    output [15:0] NewPC,
    output [1:0] ControlBTB,
	 input [1:0] JorB,
    input [3:0] WRegFW1,
    input [3:0] WRegFW2,
	 input [15:0] ALUBack,
	 input [15:0] WriteBackData
    );

reg [15:0] B0 = 16'b0;
reg [15:0] A = 16'b0;
reg [15:0] B = 16'b0;
reg [15:0] ShiftImme = 16'b0;
reg [15:0] CalPC = 16'b0;
reg [1:0] Forward = 2'b0;
reg [1:0] ForwardingA = 2'b0;
reg [1:0] ForwardingB = 2'b0;

always @(*)//mux1
begin
	if (ControlB == 2'b00)
		B0 = RData2;
	else if (ControlB == 2'b01)
		B0 = Imme;
	else
		B0 = 16'b0;
end

always @(*)//muxA
begin
	if (ForwardingA == 2'b00)
		A = RData1;
	else if (ForwardingA == 2'b01)
		A = ALUBack;
	else if (ForwardingA == 2'b10)
		A = WriteBackData;
	else
	;//δ����
end

always @(*)//muxB
begin
	if (ForwardingB == 2'b00)
		B = B0;
	else if (ForwardingB == 2'b01)
		B = ALUBack;
	else if (ForwardingB == 2'b10)
		B = WriteBackData;
	else
	;//δ����
end

always @(*)//mux2
begin
	if (Forward == 2'b00)
		WData = RData2;
	else if (ForwardingB == 2'b01)
		WData = ALUBack;
	else if (ForwardingB == 2'b10)
		WData = WriteBackData;
	else
	;//δ����
end

always @(*)//shiftleft
begin
	ShiftImme = Imme << 2;
end

always @(*)//PCAdder
begin
	CalPC = PCSrc + ShiftImme;
end

always @(*)//ALU
begin
	if (ALUOp == 4'b0000) 
		begin
			ALURes = A + B;
		end
	else if(ALUOp == 4'b0001) 
		begin
			ALURes = A - B;
		end
	else if(ALUOp == 4'b0010) 
		begin
			ALURes = A & B;
		end
	else if(ALUOp == 4'b0011) 
		begin
			ALURes = A | B;
		end
	else if(ALUOp == 4'b0100) 
		begin
			ALURes = A ^ B;
		end
	else if(ALUOp == 4'b0101) 
		begin
			ALURes = ~A;
			end
	else if(ALUOp == 4'b0110) 
		begin
			ALURes = A << B;		
		end
	else if(ALUOp == 4'b0111) 
		begin
			ALURes = A >> B;
		end
	else if(ALUOp == 4'b1000) 
		begin
			ALURes = A >>> B;
		end
	else
		begin
			ALURes = 16'b0;
		end
end

//00:B 01:J 10:B== 11��B��=
always @(*)//mux3
begin
	if (JorB == 2'b00)
		NewPC = CalPC;
	else if (JorB == 2'b01)
		NewPC = A;
	else if (JorB == 2'b10)
	begin
		if (A == 16'b0)
			NewPC = CalPC;
		else
			NewPC = PCSrc;
	end
	else
	begin
		if (A == 16'b0)
			NewPC = PCSrc;
		else
			NewPC = CalPC;
	end
end

endmodule