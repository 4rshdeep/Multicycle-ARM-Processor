//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Apr 14 09:50:30 2018
//Host        : DESKTOP-3R9NHRQ running 64-bit major release  (build 9200)
//Command     : generate_target BRAM_wrapper.bd
//Design      : BRAM_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BRAM_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_rst,
    BRAM_PORTA_0_we);
  input [31:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [31:0]BRAM_PORTA_0_din;
  output [31:0]BRAM_PORTA_0_dout;
  input BRAM_PORTA_0_en;
  input BRAM_PORTA_0_rst;
  input [3:0]BRAM_PORTA_0_we;

  wire [31:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [31:0]BRAM_PORTA_0_din;
  wire [31:0]BRAM_PORTA_0_dout;
  wire BRAM_PORTA_0_en;
  wire BRAM_PORTA_0_rst;
  wire [3:0]BRAM_PORTA_0_we;

  BRAM BRAM_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_rst(BRAM_PORTA_0_rst),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we));
endmodule
