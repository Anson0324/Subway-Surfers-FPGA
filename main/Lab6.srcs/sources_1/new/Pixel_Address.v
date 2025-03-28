`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 10:08:07 AM
// Design Name: 
// Module Name: Pixel_Address
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Pixel_Address(
    input clk,
    output [14:0] v_out, h_out
    );
    
    wire end_row = (h_out == 799);
    wire end_col = (v_out == 524);
    
    countUD15L row_counter (
    //input
      .sw(15'b0),
      .CE(1'b1),
      .UD(1'b1),
      .LD(end_row),
      .clk(clk),
    //output
      .Q(h_out),
      .UTC(),
      .DTC()
    );
    
    countUD15L column_counter (
    //input
      .sw(15'b0),
      .CE(end_row),
      .UD(1'b1),
      .LD(end_col & end_row),
      .clk(clk),
    //output
      .Q(v_out),
      .UTC(),
      .DTC()
    );
endmodule
