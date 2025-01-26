module F_pipe_reg(input clk_i,
	input F_stall_i,
	input F_bubble_i,
	input [63:0] f_predPC_i,
	output reg [63:0] F_predPC_o);
	always@ (posedge clk_i) begin
		if(F_bubble_i) begin
			F_predPC_o <= f_predPC_i;
		end
		else if(~F_stall_i) begin
			F_predPC_o <= 64'd0;
		end
	end
endmodule