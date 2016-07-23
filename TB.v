// Verilog test bench for example_3_4
`timescale 1ns/100ps
`include "PulseIntervalDetector.v"
`include "single_port_ram.v"
`include "ram_dual.v"

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
  wire ready;
  PulseIntervalDetector pulseIntDetector(clk,rst,pulse,interval,ready);

  wire [7:0]ram_q;
  reg [6:0]addr_ram;
  wire [6:0]addr_ram_p_1=addr_ram+1;
  ram_dual ramd(ram_q, addr_ram, addr_ram_p_1,{1'b1, addr_ram}, 1'b1, clk, clk);


  always@(posedge clk)addr_ram<=addr_ram+1;
  always #5 clk<=~clk;
  initial begin
    addr_ram<=0;
    clk<=0;
    rst<=1;
    #20 rst<=0;
    $dumpfile("TB.vcd");
    $dumpvars(0, TB);
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
