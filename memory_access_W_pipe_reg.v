`include "define.v"
module memory_access_W_pipe_reg(input wire clk_i,
	input wire W_stall_i,
	input wire W_bubble_i,
	input wire [2:0] m_stat_i,
	input wire [63:0] m_pc_i,
	input wire [3:0] m_icode_i,
	input wire [63:0] M_valE_i,
	input wire [63:0] m_valM_i,
	input wire [3:0] M_dstE_i,
	input wire [3:0] M_dstM_i,
	
	output reg [2:0] W_stat_o,
	output reg [63:0] W_pc_o,
	output reg [3:0] W_icode_o,
	output reg [63:0] W_valE_o,
	output reg [63:0] W_valM_o,
	output reg [3:0] W_dstE_o,
	output reg [3:0] W_dstM_o);
	always@ (posedge clk_i) begin
		if(W_bubble_i) begin
			W_stat_o <= m_stat_i;
			W_pc_o <= 64'h0;
			W_icode_o <= `NOP;
			W_valE_o <= 64'h0;
			W_valM_o <= 64'h0;
			W_dstE_o <= 4'h0;
			W_dstM_o <= 4'h0;
		end
		else if(~W_stall_i) begin
			W_stat_o <= m_stat_i;
			W_pc_o <= m_pc_i;
			W_icode_o <= m_icode_i;
			W_valE_o <= M_valE_i;
			W_valM_o <= m_valM_i;
			W_dstE_o <= M_dstE_i;
			W_dstM_o <= M_dstM_i;
		end
	end
endmodule