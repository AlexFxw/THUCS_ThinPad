`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:33 11/24/2018 
// Design Name: 
// Module Name:    InstructionMemory 
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
module InstructionMemory(
    input MemConflict,
	 input clk,
	 input rst,
    input [15:0] pc,
    output reg[15:0] Instruction
    );
 
// The size of fake memory
reg [5:0] status = 6'b000000;
reg[15:0] memPool[0:39];
reg[15:0] lastPC;

/* 根据指令名称字典序排序，便于测试，请勿修�*/
// 	16'b01000 rx ry 0 imm(4)  	//ADDIU3 	ry <- rx+imm  
// 	16'b01001 rx imm(8)			//ADDIU  	rx <- rx+imm
// 	16'b01100011 imm(8)			//ADDSP  	SP <- SP+imm
// 	16'b11100 rx ry rz 01		//ADDU   	rz <- rx+ry
// 	16'b11101 rx ry 01100       //AND    	rx <- rx&rz
// 	16'b00010 imm(11)   		//B 		pc <- pc + imm
// 	16'b00100 rx imm(8) 		//BEQZ 		rx==0 ? pc+imm : pc	
// 	16'b00101 rx imm(8)    		//BNEZ 		rx!=0 ? pc+imm : pc
// 	16'b01100000 imm(8) 		//BTEQZ 	T==0 ? pc+imm : pc
// 	16'b11101 rx ry 01010 		//CMP 		T <- (rx==ry ? 0 : 1)
// 	16'b11101 rx 00000000 		//JR 		PC <- rx
// 	16'b01101 rx imm(8)			//LI 		rx <- zeroExtend(imm)
// 	16'b10011 rx ry imm(5)		//LW 		ry <- M[rx+imm]
// 	16'b10010 rx imm(8)			//LW_SP 	rx <- M[SP+imm]
// 	16'b11110 rx 00000000 		//MFIH 		rx <- IH
// 	16'b11101 rx 01000000  		//MFPC 		rx <- PC
// 	16'b01111 rx ry 00000		//MOVE		rx <- ry
// 	16'b11110 rx 00000001 		//MTIH 		IH <- rx
// 	16'b01100100 rx 00000 		//MTSP 		SP <- rx
// 	16'b11101 rx ry 01011 		//NEG 		rx <- 0-ry
// 	16'b11101 rx ry 01111 		//NOT 		rx <- ~ry
// 	16'b0000100000000000 		//nop
// 	16'b11101 rx ry 01101		//OR 		rx <- rx|ry
// 	16'b00110 rx ry imm(3) 00 	//SLL 		rx <- ry << (imm==0 ? 8 : imm)
// 	16'b11101 rx ry 00010		//SLT  		T <- (rx<ry ? 1 : 0)
// 	16'b01011 rx imm(8)			//SLTUI		T <- (rx<zE(imm) ? 1 : 0)
// 	16'b00110 rx ry imm(3) 00 	//SRA 		rx <- ry >> (imm==0 ? 8 : imm)
// 	16'b11100 rx ry rz 11		//SUBU		rz <- rx-ry
// 	16'b11011 rx ry imm(5)		//SW 		M[rx+imm] <- ry
// 	16'b11010 rx imm(8)			//SW_SP		M[SP+imm] <- ry
always @(negedge rst)
begin
	memPool[0] = 16'b0100100100000111; //Reg1 addiu 7
	memPool[1] = 16'b0001000000000011; //B pc+3
	memPool[2] = 16'b0100111100000001; //Reg7 addiu 1
	//16'b0100110000000001;//nop
	memPool[3] = 16'b0100101000000001; //Reg2 addiu 1
	memPool[4] = 16'b1110000111100111; //R1=r1-r7
	memPool[5] = 16'b0010100011111101; //BNEZ r0!=0 ? pc-3 : pc
	memPool[6] = 16'b0000100000000000;//nop
	memPool[7] = 16'b0100111000000001; //Reg6 addiu 1
	memPool[8] = 16'b0010000000000010; //BEQZ r0->pc+8
	memPool[9] = 16'b0000100000000000;//nop
	memPool[10] = 16'b0100111100000001; //Reg7 addiu 1
	memPool[11] = 16'b0110000000000010; //BTEQZ pc+8
	memPool[12] = 16'b0100111011111111; //ADDIU R4 FF

	memPool[13] = 16'b0110110100000001; //LI r5 1
	memPool[14] = 16'b0010110100000001; //BNEZ
	memPool[15] = 16'b0000100000000000; //nop
	//16'b0110001100001100; //ADDSP SP <- SP + 12
	//16'b0100000000101011; //ADDIU3 R1 <- R0 + 11
	memPool[16] = 16'b1101001000000100; //SW_SP M[SP+4] <- R2 16
	//16'b0110100100000011; //LI Reg1 3
	memPool[17] = 16'b0110000000000010; //BTEQZ
	//16'b1001110000001001; //LW R0 <- M[R4+9] 4 (26
	//16'b0101100100000000; //SLTUI R1 0  T <- 0
	memPool[18] = 16'b0000100000000000; //nop
	//16'b1001001100000100; //LW_SP R3 <- M[SP+4] 16
	//16'b0101100111111111; //SLTUI R1 FF T <- 1
	memPool[19] = 16'b1110110101101100; //AND R5 <- R3 & R5
	//16'b0110010000100000; //MTSP SP <- R1(3)
	memPool[20] = 16'b1111000000000000; 		//MFIH 
	//16'b1110110100000000;
	//16'b0110001100001100; //ADDSP SP <- SP + 12
	memPool[21] = 16'b1110111100000000; //JR
	//16'b0000100000000000;
	//16'b0111100000100000; //MOVE R0 <- R1
	memPool[22] = 16'b0000100000000000;
	//16'b0111100000100000;
	//16'b1101100000100100; //SW M[R0+4] <- R1
	memPool[23] = 16'b1101000000000100; //SW_SP M[SP+4] <- R0
	memPool[24] = 16'b0110101010110101; //LI Reg2 ***
	memPool[25] = 16'b0110101101101011; //LI Reg3 ***
	memPool[26] = 16'b1110001001110011; //SUBU R4 <- R2 - R3
	memPool[27] = 16'b1110110101101100; //AND R5 <- R3 & R5
	memPool[28] = 16'b1110110110101010; //CMP(R5, R5) T <- 0
 	memPool[29] = 16'b1110110110001010; //CMP(R4, R5) T <- 1
	memPool[30] = 16'b1110111001000000; //MFPC R6 <- PC
	memPool[31] = 16'b1110111111001011; //NEG R7 <- 0 - R6
	memPool[32] = 16'b1110100011101111; //NOT R0 <- ~R7
	memPool[33] = 16'b1110100100001101; //OR R1 <- R0 | R1
	memPool[34] = 16'b1110100100000010; //SLT R1 R0 T <- 0
	memPool[35] = 16'b1110100000100010; //SLT R0 R1 T <- 1
	memPool[36] = 16'b1111000100000001; //MTIH IH <- R1
	memPool[37] = 16'b1111001000000000; //MFIH R2 <- IH
	memPool[38] = 16'b1001101000000100; //LW R0 <- M[R2+4]
	memPool[39] = 16'b1001001100000100; //LW_SP R3 <- M[SP+4]

	// lastPC <= 16'b0;
	status <= 0;
end

always @(*) begin
	status = (pc >> 2) % 32; 
end

always @(pc)
begin
	// if(pc - lastPC == 4 || lastPC == 16'b0)
	// begin
	// 	if(status == 22)
	// 		status <= 0;
	// 	else
	// 		status <= status + 1;
	// 	lastPC[15:0] <= pc;
	// 	Instruction[15:0] <= memPool[status];
	// end
	// status <= (pc >> 2) % 39;
	// lastPC[15:0] <= pc;
	Instruction[15:0] <= memPool[(pc >> 2) % 32];
end

endmodule
