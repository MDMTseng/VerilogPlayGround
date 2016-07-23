module PulseIntervalDetector
#(
parameter
OutDepth=32
)(
input clk,
input rst,
input pulse,
output [OutDepth-1:0]intervalValue,
output ready
  );
reg [OutDepth-1:0]regIntervalValue;
assign intervalValue=regIntervalValue;
reg [OutDepth-1:0]countValue;

reg [1:0]pulse_shiftReg;
always@(posedge clk)begin
  if(rst)begin
    countValue<=0;
    regIntervalValue<=0;
  end else begin
    pulse_shiftReg <= {pulse_shiftReg[0],pulse};
    if( pulse_shiftReg == 2'b10 )begin
      regIntervalValue <= countValue;
      countValue<=0;
    end else begin
      countValue<=countValue+1;
    end
  end
end



wire pulseStable =(pulse_shiftReg == 2'b00);
reg preReady;
assign ready = pulseStable & ~preReady;
always@(posedge clk)begin

  preReady <= pulseStable;
end



endmodule
