`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:56 11/28/2018 
// Design Name: 
// Module Name:    BTB 
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
module BTB(
	input rst,
	input clk,
	input [15:0] curPC,
	output reg [15:0] prePC,
	input ifJump_id,

	input [15:0] jFromPC,	//å®žé™…ä¸ºè·³è½¬æŒ‡ä»¤çš„ä¸‹ä¸€è·
	input [15:0] jToPC,		//è·³è½¬åˆ°çš„åœ°å€	
	input ifJump,
	output reg error
    );

reg [15:0] toPC [15:0];		//value
always @(posedge clk or negedge rst) begin  	//å†™è¡¨
	if (rst == 0) begin
		error <= 0;
		toPC[0] <= 16'b0000000000000001;
		toPC[1] <= 16'b0000000000000010;
		toPC[2] <= 16'b0000000000000011;
		toPC[3] <= 16'b0000000000000100;
		toPC[4] <= 16'b0000000000000101;
		toPC[5] <= 16'b0000000000000110;
		toPC[6] <= 16'b0000000000000111;
		toPC[7] <= 16'b0000000000001000;
		toPC[8] <= 16'b0000000000001001;
		toPC[9] <= 16'b0000000000001010;
		toPC[10] <= 16'b0000000000001011;
		toPC[11] <= 16'b0000000000001100;
		toPC[12] <= 16'b0000000000001101;
		toPC[13] <= 16'b0000000000001110;
		toPC[14] <= 16'b0000000000001111;
		toPC[15] <= 16'b0000000000010000;
	end
	else if (ifJump === 0) begin //å¦‚æžœæ˜¯è·³è½¬æŒ‡�
		if(toPC[jFromPC[3:0]] != jToPC) begin
			error <= 1;
			toPC[jFromPC[3:0]] <= jToPC;
		end
		else begin
			error <= 0;
		end
	end
	else begin
		error <= 0;
	end
end

always @(ifJump_id or curPC or rst) begin 	//curPCΪ��ǰPC��ϣ�����Ԥ��PCΪprePC
	if(rst == 0)  begin
		prePC = 0;
	end
	else if(ifJump_id === 0) //toPCΪԤ���
			prePC = toPC[curPC[3:0]];
	else 	prePC = curPC + 1;
end

endmodule
