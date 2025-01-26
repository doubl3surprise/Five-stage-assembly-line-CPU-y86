`include "define.v"
module memory_access(input wire clk_i,
	input wire [3:0] M_icode_i,
	input wire [63:0] M_valE_i,
	input wire [63:0] M_valA_i,
	input wire [2:0] M_stat_i,

	output wire [63:0] m_valM_o,
	output wire [2:0] m_stat_o);
	reg r_en;
	reg w_en;
	reg [63:0] mem_addr;
	always@ (*) begin
		case (M_icode_i)
			`RMMOVQ: begin
				r_en <= 1'b0;
				w_en <= 1'b1;
				mem_addr <= M_valE_i;
			end
			`MRMOVQ: begin
				r_en <= 1'b1;
				w_en <= 1'b0;
				mem_addr <= M_valE_i;
			end
			`POPQ: begin
				r_en <= 1'b1;
				w_en <= 1'b0;
				mem_addr <= M_valA_i;
			end
			default: begin
				r_en <= 0;
				w_en <= 0;
				mem_addr <= 0;
			end
		endcase
	end
	assign dmem_error = (mem_addr > 1023) ? 1 : 0;
	assign m_stat_o = (dmem_error) ? `SADR : M_stat_i;
	ram memory_module(
		.clk_i(clk_i),
		.r_en_i(r_en),
		.w_en_i(w_en),
		.addr_i(mem_addr),
		.wdata_i(M_valA_i),

		.rdata__o(m_valM_o),
		.dmem_error_o(dmem_error));
				
endmodule