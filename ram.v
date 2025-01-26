module ram(input wire clk_i,
	input wire r_en_i,
	input wire w_en_i,
	input wire [63:0] addr_i,
	input wire [63:0] wdata_i,
	
	output wire [63:0] rdata_o,
	output wire dmem_error_o);
	reg [7:0] mem[1023:0];
	integer i;
	initial begin
		mem[0] = 8'h00; mem[1] = 8'h01; mem[2] = 8'h02;
		mem[3] = 8'h03; mem[4] = 8'h04; mem[5] = 8'h05;
		mem[6] = 8'h06; mem[7] = 8'h07; mem[8] = 8'h08;
		mem[9] = 8'h09; mem[10] = 8'h0a; mem[11] = 8'h0b;
		mem[12] = 8'h0c; mem[13] = 8'h0d; mem[14] = 8'h0e;
		mem[15] = 8'h0f; mem[16] = 8'h10; mem[17] = 8'h11;
		mem[18] = 8'h12; mem[19] = 8'h13; mem[20] = 8'h14;
		mem[21] = 8'h15; mem[22] = 8'h16; mem[23] = 8'h17;
		mem[24] = 8'h18; mem[25] = 8'h19; mem[26] = 8'h1a;
		mem[27] = 8'h1b; mem[28] = 8'h1c; mem[29] = 8'h1d;
		for(i = 30; i < 1024; i = i + 1) begin
			mem[i] = 8'd0;
		end
	end
	always@ (posedge clk_i) begin
		if(w_en_i) begin
			{mem[7 + addr_i], mem[6 + addr_i], mem[5 + addr_i], 
			mem[4 + addr_i], mem[3 + addr_i], mem[2 + addr_i], 
			mem[1 + addr_i], mem[addr_i]} <= wdata_i;
		end
	end
	assign rdata_o = (r_en_i) ? 
		{mem[7 + addr_i], mem[6 + addr_i], mem[5 + addr_i], 
		mem[4 + addr_i], mem[3 + addr_i], mem[2 + addr_i], 
		mem[1 + addr_i], mem[addr_i]} : 64'd0;
endmodule