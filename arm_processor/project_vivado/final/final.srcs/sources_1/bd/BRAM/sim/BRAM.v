//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Apr 14 09:50:30 2018
//Host        : DESKTOP-3R9NHRQ running 64-bit major release  (build 9200)
//Command     : generate_target BRAM.bd
//Design      : BRAM
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "BRAM,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=BRAM,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "BRAM.hwdef" *) 
module BRAM
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_rst,
    BRAM_PORTA_0_we);
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA_0, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_WRITE_MODE READ_WRITE" *) input [31:0]BRAM_PORTA_0_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 CLK" *) input BRAM_PORTA_0_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 DIN" *) input [31:0]BRAM_PORTA_0_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 DOUT" *) output [31:0]BRAM_PORTA_0_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 EN" *) input BRAM_PORTA_0_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 RST" *) input BRAM_PORTA_0_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 WE" *) input [3:0]BRAM_PORTA_0_we;

  wire [31:0]BRAM_PORTA_0_1_ADDR;
  wire BRAM_PORTA_0_1_CLK;
  wire [31:0]BRAM_PORTA_0_1_DIN;
  wire [31:0]BRAM_PORTA_0_1_DOUT;
  wire BRAM_PORTA_0_1_EN;
  wire BRAM_PORTA_0_1_RST;
  wire [3:0]BRAM_PORTA_0_1_WE;

  assign BRAM_PORTA_0_1_ADDR = BRAM_PORTA_0_addr[31:0];
  assign BRAM_PORTA_0_1_CLK = BRAM_PORTA_0_clk;
  assign BRAM_PORTA_0_1_DIN = BRAM_PORTA_0_din[31:0];
  assign BRAM_PORTA_0_1_EN = BRAM_PORTA_0_en;
  assign BRAM_PORTA_0_1_RST = BRAM_PORTA_0_rst;
  assign BRAM_PORTA_0_1_WE = BRAM_PORTA_0_we[3:0];
  assign BRAM_PORTA_0_dout[31:0] = BRAM_PORTA_0_1_DOUT;
  BRAM_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(BRAM_PORTA_0_1_ADDR),
        .clka(BRAM_PORTA_0_1_CLK),
        .dina(BRAM_PORTA_0_1_DIN),
        .douta(BRAM_PORTA_0_1_DOUT),
        .ena(BRAM_PORTA_0_1_EN),
        .rsta(BRAM_PORTA_0_1_RST),
        .wea(BRAM_PORTA_0_1_WE));
endmodule
