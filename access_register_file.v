module access_register_file(input wire clk_i,
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

	input wire [3:0] d_srcA_i,
	input wire [3:0] d_srcB_i,
	
	output wire [63:0] d_valA_o,
	output wire [63:0] d_valB_o);
	reg [63:0] reg_file [14:0];
	wire [3:0] d_rvalA;
	wire [3:0] d_rvalB;	
	initial begin
		reg_file[0] = 64'd0;
		reg_file[1] = 64'd1;
		reg_file[2] = 64'd2;
		reg_file[3] = 64'd3;
		reg_file[4] = 64'd512;
		reg_file[5] = 64'd5;
		reg_file[6] = 64'd6;
		reg_file[7] = 64'd7;
		reg_file[8] = 64'd8;
		reg_file[9] = 64'd9;
		reg_file[10] = 64'd10;
		reg_file[11] = 64'd11;
		reg_file[12] = 64'd12;
		reg_file[13] = 64'd13;
		reg_file[14] = 64'd14;
	end
	assign d_rvalA = (d_srcA_i == 4'hf) ? 64'd0 : reg_file[d_srcA_i];
	assign d_rvalB = (d_srcB_i == 4'hf) ? 64'd0 : reg_file[d_srcB_i];
	
	sel_fwd fwd_A(.D_icode_i(D_icode_i),
		.D_valP_i(D_valP_i),
		.d_srcA_i(d_srcA_i),
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
		.d_rvalA_i(d_rvalA_i),
		.fwdA_valA_o(d_valA_o));

	fwd fwd_B(.d_srcB_i(d_srcB_i),
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
		.d_rvalB_i(d_rvalB_i),
		.fwdB_valB_o(d_valB_o));
	
	always@ (posedge clk_i) begin
		if(W_dstE_i != 4'hf) begin
			reg_file[W_dstE_i] <= W_valE_i;
		end
		if(W_dstM_i != 4'hf) begin
			reg_file[W_dstM_i] <= W_valM_i;
		end
	end
endmodule