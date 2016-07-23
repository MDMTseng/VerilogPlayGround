
module LightBoat
#(
parameter
OutDepth=32

)(
input clk,
input rst,
input lightHousePulse,
output [OutDepth-1:0]dataValue,

output[7:0] errorCode
  );
    wire[32-1:0] interval;
    assign dataValue= interval;
    wire ready;
    assign errorCode = !ready;
    PulseIntervalDetector #(.OutDepth(OutDepth)) pulseIntDetector(clk,rst,lightHousePulse,interval,ready);

    wire [32-1:0]ram_q;
    FIFO #(.DataDepth(OutDepth))fifo_t(clk,rst,
    ready,w_ready,interval,1'b1,r_ready,ram_q,fifo_size);



endmodule
