// Verilog test bench for example_3_4
`timescale 1ns/100ps

`include "LightBoat.v"
`include "PulseIntervalDetector.v"
`include "ram_dual.v"
`include "FIFO.v"

`define PULSE_STIMULATOR(WIDTH,PULSE)  pulse<=1; #WIDTH pulse<=0;


`define LIGHTHOUSEPULSE_SIMULATOR(WIDTH,DUTYCYCLE,PULSE)  \
  `PULSE_STIMULATOR(WIDTH,PULSE);\
  #15 \
  `PULSE_STIMULATOR(WIDTH,PULSE);\
  #(1000-DUTYCYCLE) \
  `PULSE_STIMULATOR(WIDTH,PULSE);\
  #(DUTYCYCLE)



module TB;

  reg clk,rst,pulse;


  wire[32-1:0] interval;

  wire[7:0] errorCode;
  reg[32-1:0] CCCCCC;
  LightBoat lb_m(clk,rst,pulse,interval,errorCode);

  wire[32-1:0] RRRRRR;
  reg r_en,w_en;
  FIFO fifo_t(clk,rst,
  w_en,w_ready,CCCCCC,r_en,r_ready,RRRRRR,fifo_size);
  always #5 clk<=~clk;
  initial begin
    CCCCCC<=0;
    clk<=0;
    rst<=1;

    w_en = 1;
    r_en = 0;
    #20 rst<=0;
    $dumpfile("TB.vcd");
    $dumpvars(0, TB);

    #300 r_en=1;
    #500 w_en=0;
  end

  always@(posedge clk)
  begin
    #1
    //w_en = $random;
    if(w_en&w_ready)
      CCCCCC=CCCCCC+1;
  end
  initial begin
    pulse<=0;
    #130
    `LIGHTHOUSEPULSE_SIMULATOR(15,500,pulse);
    `LIGHTHOUSEPULSE_SIMULATOR(15,100,pulse);
    `LIGHTHOUSEPULSE_SIMULATOR(15,700,pulse);
    `LIGHTHOUSEPULSE_SIMULATOR(15,100,pulse);
    $finish;
  end



endmodule
