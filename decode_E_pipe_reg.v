`include "define.v"
module decode_E_pipe_reg(input wire clk_i,
	input wire E_stall_i,
	input wire E_bubble_i,
	input wire [2:0] d_stat_i,
	input wire [63:0] d_pc_i,
	input wire [3:0] d_icode_i,
	input wire [3:0] d_ifun_i,
	input wire [63:0] d_valC_i,
	input wire [63:0] d_valA_i,
	input wire [63:0] d_valB_i,
	input wire [3:0] d_dstE_i,
	input wire [3:0] d_dstM_i,
	input wire [3:0] d_srcA_i,
	input wire [3:0] d_srcB_i,
	
	output reg [2:0] E_stat_o,
	output reg [63:0] E_pc_o,
	output reg [3:0] E_icode_o,
	output reg [3:0] E_ifun_o,
	output reg [63:0] E_valC_o,
	output reg [63:0] E_valA_o,
	output reg [63:0] E_valB_o,
	output reg [3:0] E_dstE_o,
	output reg [3:0] E_dstM_o,
	output reg [3:0] E_srcA_o,
	output reg [3:0] E_srcB_o);
	
	always@ (posedge clk_i) begin
		if(E_bubble_i) begin
			E_stat_o <= d_stat_i;
			E_pc_o <= 64'd0;
			E_icode_o <= `NOP;
			E_ifun_o <= 4'd0;
			E_valC_o <= 64'd0;
			E_valA_o <= 64'd0;
			E_valB_o <= 64'd0;
			E_dstE_o <= 4'hf;
			E_dstM_o <= 4'hf;
			E_srcA_o <= 4'hf;
			E_srcB_o <= 4'hf;
		end
		else if(~E_stall_i) begin
			E_stat_o <= d_stat_i;
			E_pc_o <= d_pc_i;
			E_icode_o <= d_icode_i;
			E_ifun_o <= d_ifun_i;
			E_valC_o <= d_valC_i;
			E_valA_o <= d_valA_i;
			E_valB_o <= d_valB_i;
			E_dstE_o <= d_dstE_i;
			E_dstM_o <= d_dstM_i;
			E_srcA_o <= d_srcA_i;	
			E_srcB_o <= d_srcB_i;
		end
	end
endmodule