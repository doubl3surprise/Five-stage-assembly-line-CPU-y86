`include "define.v"
module select_pc(input reg [63:0] F_predPC_i,
	input wire [3:0] M_icode_i,
	input wire M_Cnd_i,
	input wire [63:0] M_valA_i,
	input wire [3:0] W_icode_i,
	input wire [63:0] W_valM_i,
	output reg [63:0] f_pc_o);
	always@ (*) begin
		if(M_icode_i == `JXX && !M_Cnd_i) begin
			f_pc_o = M_valA_i;
		end
		else if(W_icode_i == `RET) begin
			f_pc_o = W_valM_i;
		end
		else begin
			f_pc_o = F_predPC_i;
		end
	end
endmodule