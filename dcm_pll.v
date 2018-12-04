////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 14.7
//  \   \         Application : xaw2verilog
//  /   /         Filename : dcm_pll.v
// /___/   /\     Timestamp : 12/04/2018 15:11:10
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: xaw2verilog -intstyle D:/THUCS_ThinPad/ipcore_dir/dcm_pll.xaw -st dcm_pll.v
//Design Name: dcm_pll
//Device: xc3s1200e-4fg320
//
// Module dcm_pll
// Generated by Xilinx Architecture Wizard
// Written for synthesis tool: XST
`timescale 1ns / 1ps

module dcm_pll(CLKIN_IN, 
               RST_IN, 
               CLK0_OUT, 
               CLK2X_OUT, 
               LOCKED_OUT);

    input CLKIN_IN;
    input RST_IN;
   output CLK0_OUT;
   output CLK2X_OUT;
   output LOCKED_OUT;
   
   wire CLKFB_IN;
   wire CLK0_BUF;
   wire CLK2X_BUF;
   wire GND_BIT;
   
   assign GND_BIT = 0;
   assign CLK2X_OUT = CLKFB_IN;
   BUFG  CLK0_BUFG_INST (.I(CLK0_BUF), 
                        .O(CLK0_OUT));
   BUFG  CLK2X_BUFG_INST (.I(CLK2X_BUF), 
                         .O(CLKFB_IN));
   DCM_SP #( .CLK_FEEDBACK("2X"), .CLKDV_DIVIDE(2.0), .CLKFX_DIVIDE(1), 
         .CLKFX_MULTIPLY(4), .CLKIN_DIVIDE_BY_2("FALSE"), 
         .CLKIN_PERIOD(80.000), .CLKOUT_PHASE_SHIFT("FIXED"), 
         .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), .DFS_FREQUENCY_MODE("LOW"), 
         .DLL_FREQUENCY_MODE("LOW"), .DUTY_CYCLE_CORRECTION("TRUE"), 
         .FACTORY_JF(16'hC080), .PHASE_SHIFT(37), .STARTUP_WAIT("FALSE") ) 
         DCM_SP_INST (.CLKFB(CLKFB_IN), 
                       .CLKIN(CLKIN_IN), 
                       .DSSEN(GND_BIT), 
                       .PSCLK(GND_BIT), 
                       .PSEN(GND_BIT), 
                       .PSINCDEC(GND_BIT), 
                       .RST(RST_IN), 
                       .CLKDV(), 
                       .CLKFX(), 
                       .CLKFX180(), 
                       .CLK0(CLK0_BUF), 
                       .CLK2X(CLK2X_BUF), 
                       .CLK2X180(), 
                       .CLK90(), 
                       .CLK180(), 
                       .CLK270(), 
                       .LOCKED(LOCKED_OUT), 
                       .PSDONE(), 
                       .STATUS());
endmodule
