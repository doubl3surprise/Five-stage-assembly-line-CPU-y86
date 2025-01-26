`include "define.v"
module execute(input wire clk_i,
	input wire rst_n_i,

	input wire [3:0] E_icode_i,
	input wire [3:0] E_ifun_i,
	input wire signed [63:0] E_valA_i,
	input wire signed [63:0] E_valB_i,
	input wire signed [63:0] E_valC_i,
	input wire [3:0] E_dstE_i,

	input wire [2:0] m_stat_i,
	input wire [2:0] W_stat_i,

	output wire signed [63:0] e_valE_o,
	output wire [3:0] e_dstE_o,
	output wire [3:0] e_cnd_o);
	wire [63:0] aluA;
	wire [63:0] aluB;
	wire [3:0] alu_fun;
	wire [2:0] nw_cc;
	reg [2:0] cc;
	wire zf = cc[2];
	wire sf = cc[1];
	wire of = cc[0];
	assign e_dstE_o = E_dstE_i;
	assign aluA = (E_icode_i == `CMOVXX || E_icode_i == `OPQ)
		 ? E_valA_i : (E_icode_i == `IRMOVQ || E_icode_i == `RMMOVQ)
		 ? E_valC_i : (E_icode_i == `CALL || E_icode_i == `PUSHQ)
		 ? -8 : (E_icode_i == `RET || E_icode_i == `POPQ) ? 8 : 0;
	assign aluB = (E_icode_i == `CMOVXX || E_icode_i == `MRMOVQ || E_icode_i == `OPQ || E_icode_i == `CALL || E_icode_i == `RET)
		 ? E_valB_i : (E_icode_i == `PUSHQ)
		 ? -8 : (E_icode_i == `POPQ) ? 8 : 0;
	assign alu_fun = (E_icode_i == `OPQ) ? E_ifun_i : `ALUADD;
	assign e_valE_o = (alu_fun == `ALUSUB)
		 ? (aluA - aluB) : (alu_fun == `ALUAND)
		 ? (aluA & aluB) : (alu_fun == `ALUXOR)
		 ? (aluA ^ aluB) : (aluA + aluB);
	assign nw_cc = (rst_n_i) ? 3'b100 : 
               (E_icode_i == `OPQ) ? {(e_valE_o == 0), (e_valE_o[63]),  
               (alu_fun == `ALUADD && aluA[63] != e_valE_o[63] && aluA[63] != e_valE_o[63]) || 
               (alu_fun == `ALUSUB && aluA[63] != aluB[63] && aluB[63] != e_valE_o[63])}
		: cc;

	assign set_cc = (E_icode_i == `OPQ);
	
	always@ (posedge clk_i) begin
		if(rst_n_i) begin
			cc <= 3'b100;
		end
		else if(set_cc) begin
			cc <= nw_cc;
		end
	end
	assign e_cnd_o = 
		(E_ifun_i == `C_YES) | 
		(E_ifun_i == `C_LE & ((sf ^ of) | zf)) | 
		(E_ifun_i == `C_L & (sf ^ of)) | 
		(E_ifun_i == `C_E & zf) |
		(E_ifun_i == `C_NE & ~zf) |
		(E_ifun_i == `C_GE & ~(sf ^ of)) |
		(E_ifun_i == `C_G & (~(sf ^ of) & ~zf));
endmodule	