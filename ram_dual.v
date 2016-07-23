
module ram_dual#(
parameter
DataDepth=32,
AddrBitWidth=8
)(clk1, we, addr_in, d, addr_out, q );
   output[DataDepth-1:0] q;
   input [DataDepth-1:0] d;
   input [AddrBitWidth-1:0] addr_in;
   input [AddrBitWidth-1:0] addr_out;
   input we, clk1, clk2;

   reg [AddrBitWidth-1:0] addr_out_reg;
   reg [DataDepth-1:0] mem [2**AddrBitWidth-1:0];
   wire [DataDepth-1:0] q = mem[addr_out];

   always @(posedge clk1) begin
      if (we)begin
         mem[addr_in] <= d;
      end
   end


endmodule
