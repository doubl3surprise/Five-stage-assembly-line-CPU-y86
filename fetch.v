`include "define.v"
module fetch (input wire [63:0] f_pc_i, 
	output wire [3:0] f_icode_o, 
	output wire [3:0] f_ifun_o, 
	output wire [3:0] f_rA_o,
	output wire [3:0] f_rB_o, 
	output wire [63:0] f_valC_o,
	output wire f_valP_o,
	output wire f_predPC_o,
	output wire f_stat_o);
	wire [79:0] nw_instr;
	wire imem_error, instr_valid, valid_reg, valid_valc;
	instruction_memory instr_mem(
		.pc_i(f_pc_i),
		.nw_instr_o(nw_instr),
		.imem_error_o(imem_error));

	assign f_icode_o = nw_instr[7:4];
	assign f_ifun_o = nw_instr[3:0];
	assign valid_reg = (f_icode_o == `IRMOVQ) | (f_icode_o == `RMMOVQ) 
		| (f_icode_o == `MRMOVQ) | (f_icode_o == `OPQ)| (f_icode_o == `CMOVXX) 
		| (f_icode_o == `PUSHQ) | (f_icode_o == `POPQ);
	assign valid_valc = ((f_icode_o == `IRMOVQ) | (f_icode_o == `RMMOVQ) 
		|(f_icode_o == `MRMOVQ) | (f_icode_o == `JXX) | (f_icode_o == `CALL));
	assign f_ra_o = valid_reg ? nw_instr[15:12] : 4'hf;
	assign f_rb_o = valid_reg ? nw_instr[11:8] : 4'hf;
	assign f_valc_o = valid_valc ? (valid_reg ? nw_instr[79:16] : nw_instr[71:8]) : 64'd0;
	assign f_valp_o = f_pc_i + 1 + valid_reg + valid_valc * 8;
	assign f_predPC_o = (f_icode_o == `JXX || f_icode_o == `CALL) ? f_valc_o : f_valp_o;
	
	assign instr_valid = (nw_instr[7:4] <= 4'hb);
	assign f_stat_o = imem_error ? `SADR : (!instr_valid) ? `SINS : (f_icode_o == `HALT) ? `SHLT : `SOK;
endmodule
