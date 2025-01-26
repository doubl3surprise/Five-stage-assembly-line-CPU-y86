module instruction_memory(input wire [63:0] pc_i,
	output wire [79:0] nw_instr_o,
	output wire imem_error_o);
	reg [7:0] ins_mem [1023:0];
	// initaial instruction memory
	integer i;
	initial begin
		//irmovq $0x8 %r8
		ins_mem[0] = 8'h30; ins_mem[1] = 8'hf8; ins_mem[2] = 8'h08;
		ins_mem[3] = 8'h00; ins_mem[4] = 8'h00; ins_mem[5] = 8'h00;
		ins_mem[6] = 8'h00; ins_mem[7] = 8'h00; ins_mem[8] = 8'h00;
		ins_mem[9] = 8'h00;
		//irmovq $0x21 %rbx
		ins_mem[10] = 8'h30; ins_mem[11] = 8'hf3; ins_mem[12] = 8'h15;
		ins_mem[13] = 8'h00; ins_mem[14] = 8'h00; ins_mem[15] = 8'h00;
		ins_mem[16] = 8'h00; ins_mem[17] = 8'h00; ins_mem[18] = 8'h00;
		ins_mem[19] = 8'h00;
		//halt
		ins_mem[20] = 8'h00;
		//nop
		ins_mem[21] = 8'h10;
		//rrmovq
		ins_mem[22] = 8'h20; ins_mem[23] = 8'h13;
		//rmmovq
		ins_mem[24] = 8'h40; ins_mem[25] = 8'h2d; ins_mem[26] = 8'h15;
		ins_mem[27] = 8'h00; ins_mem[28] = 8'h00; ins_mem[29] = 8'h00;
		ins_mem[30] = 8'h00; ins_mem[31] = 8'h00; ins_mem[32] = 8'h00;
		ins_mem[33] = 8'h00;
		//mrmovq
		ins_mem[34] = 8'h50; ins_mem[35] = 8'h2d; ins_mem[36] = 8'h15;
		ins_mem[37] = 8'h00; ins_mem[38] = 8'h00; ins_mem[39] = 8'h00;
		ins_mem[40] = 8'h00; ins_mem[41] = 8'h00; ins_mem[42] = 8'h00;
		ins_mem[43] = 8'h00;
		//opq / add %r9 %r7
		ins_mem[44] = 8'h60; ins_mem[45] = 8'h97;
		//opq / sub %r8 %r10
		ins_mem[46] = 8'h61; ins_mem[47] = 8'h97;
		//opq / and %r14 %rax
		ins_mem[48] = 8'h62; ins_mem[49] = 8'he1;
		//opq / xor %r13 %r12
		ins_mem[50] = 8'h63; ins_mem[51] = 8'hdb;

		for(i = 52; i < 1024; i = i + 1) begin
			ins_mem[i] = 8'hcc;
		end
	end
	assign nw_instr = {ins_mem[pc_i + 9],
		ins_mem[pc_i + 8], ins_mem[pc_i + 7],
		ins_mem[pc_i + 6], ins_mem[pc_i + 5],
		ins_mem[pc_i + 4], ins_mem[pc_i + 3],
		ins_mem[pc_i + 2], ins_mem[pc_i + 1],
		ins_mem[pc_i + 0]};
	assign imem_error_o = (pc_i >= 1023);
endmodule