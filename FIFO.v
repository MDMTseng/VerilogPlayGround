
module FIFO
#(
parameter
DataDepth=32,
AddrBitWidth=4
)(
input  clk,
input  rst,
input  w_en,
output w_ready,
input  [DataDepth-1:0]dataW,
input  r_en,
output r_ready,
output [DataDepth-1:0]dataR,
output [AddrBitWidth-1:0]fifo_size
  );
    wire [DataDepth-1:0]ram_q;
    reg [AddrBitWidth-1:0]addr_R;
    reg [AddrBitWidth-1:0]addr_W;
    reg [AddrBitWidth-1:0]fifo_size;
    reg[DataDepth-1:0] reg_interval;

    assign w_ready=!(fifo_size == (2**AddrBitWidth-1));
    assign r_ready=!(fifo_size == 0 );
    wire w_op = w_en&w_ready;
    wire r_op = r_en&r_ready;

    ram_dual # (.DataDepth(DataDepth),.AddrBitWidth(AddrBitWidth)) ramd   ( clk, w_op,  addr_W, dataW, addr_R, dataR);

    always@(posedge clk)begin
      #1
      if(rst)begin
        addr_R<=0;
        addr_W<=0;
        fifo_size<=0;
      end else begin
        case ({w_op,r_op})
          2'b00:begin
          end
          2'b01:begin
            addr_R<=addr_R+1;
            fifo_size <= fifo_size - 1;
          end
          2'b10:begin
            addr_W<=addr_W+1;
            fifo_size <= fifo_size + 1;
          end
          2'b11:begin
            addr_W<=addr_W+1;
            addr_R<=addr_R+1;
          end
        endcase
      end
    end

endmodule
