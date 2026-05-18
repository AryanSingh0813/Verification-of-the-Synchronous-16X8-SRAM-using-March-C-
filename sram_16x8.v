`timescale 1ns / 1ps
module sram16_8(

  input [3:0] addr,
  input [7:0] din,
  input clk,
  input ce,
  input wr,
  
  output reg [7:0] dout
  
);
  
  reg [7:0]mem[0:15];
 integer i;
 
  initial begin
    for(i = 0; i < 16; i = i + 1)begin
      mem[i] = 0;
    end
  end
  
  always@(posedge clk)begin
    if(ce)begin
      if(wr) mem[addr] <= din;
      else dout <= mem[addr];
    end
  end
  
  
endmodule