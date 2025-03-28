`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 10:54:31 AM
// Design Name: 
// Module Name: Syncs
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


module Syncs(
    input clk,
   
    output Hsync, Vsync
    );
    
    wire [14:0] v_out;
    wire [14:0] h_out;
    
    Pixel_Address Pixel_Add (
        .clk(clk),
        .v_out(v_out),
        .h_out(h_out)
    );
    
    assign Hsync = ~((655 <= h_out) & (h_out <= 750));
    assign Vsync = ~((489 <= v_out) & (v_out <= 490));
    
endmodule
