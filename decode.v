`include "define.v"
module decode(input wire clk_i,
	input wire [3:0] D_icode_i,
	input wire [3:0] D_rA_i,
	input wire [3:0] D_rB_i,
	input wire [63:0] D_valP_i,
	
	input wire [3:0] e_dstE_i,
	input wire [63:0] e_valE_i,
	input wire [3:0] M_dstM_i,
	input wire [63:0] m_valM_i,
	input wire [3:0] M_dstE_i,
	input wire [63:0] M_valE_i,
	input wire [3:0] W_dstM_i,
	input wire [63:0] W_valM_i,
	input wire [3:0] W_dstE_i,
	input wire [63:0] W_valE_i,

	output wire [63:0] d_valA_o,
	output wire [63:0] d_valB_o,
	output wire [3:0] d_dstE_o,
	output wire [3:0] d_dstM_o,
	output wire [3:0] d_srcA_o,
	output wire [3:0] d_srcB_o);
	
	assign d_srcA_o = (D_icode_i == `CMOVXX || D_icode_i == `RMMOVQ || D_icode_i == `OPQ || D_icode_i == `PUSHQ)
		 ? D_rA_i : (D_icode_i == `POPQ || D_icode_i == `RET)
		 ? 4'h4 : 4'hf;
	assign d_srcB_o = (D_icode_i == `OPQ || D_icode_i == `RMMOVQ || D_icode_i == `MRMOVQ)
		 ? D_rB_i : (D_icode_i == `CALL || D_icode_i == `PUSHQ || D_icode_i == `RET)
		 ? 4'h4 : 4'hf;
	assign d_dstE_o = (D_icode_i == `CMOVXX || D_icode_i == `IRMOVQ || D_icode_i == `OPQ)
		 ? D_rB_i : (D_icode_i == `PUSHQ || D_icode_i == `POPQ || D_icode_i == `CALL || D_icode_i == `RET)
		 ?  'h4 : 4'hf;
	assign d_dstM_o = (D_icode_i == `MRMOVQ || D_icode_i == `POPQ) ? D_rA_i : 4'h0;
	access_register_file acc_reg_file(.clk_i(clk),
		.D_icode_i(D_icode_i),
		.D_rA_i(D_rA_i),
		.D_rB_i(D_rB_i),
		.D_valP_i(D_valP_i),
		.e_dstE_i(e_dstE_i),
		.e_valE_i(e_valE_i),
		.M_dstM_i(M_dstM_i),
		.m_valM_i(m_valM_i),
		.M_dstE_i(M_dstE_i),
		.M_valE_i(M_valE_i),
		.W_dstM_i(W_dstM_i),
		.W_valM_i(W_valM_i),
		.W_dstE_i(W_dstE_i),
		.W_valE_i(W_valE_i),
		.d_srcA_i(d_srcA_o),
		.d_srcB_i(d_srcB_o),
		.d_valA_o(d_valA_o),
		.d_valB_o(d_valB_o));
	
endmodule