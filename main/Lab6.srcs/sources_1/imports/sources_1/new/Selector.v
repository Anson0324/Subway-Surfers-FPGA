`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2024 01:52:50 PM
// Design Name: 
// Module Name: Selector
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


module Selector(
    input [15:0] N,
    input [3:0] sel,
    output [3:0] H
    );
    
    assign H[0] = (N[12] & sel[3]) | (N[8] & sel[2]) | (N[4] & sel[1]) | (N[0] & sel[0]);
    assign H[1] = (N[13] & sel[3]) | (N[9] & sel[2]) | (N[5] & sel[1]) | (N[1] & sel[0]);
    assign H[2] = (N[14] & sel[3]) | (N[10] & sel[2]) | (N[6] & sel[1]) | (N[2] & sel[0]);
    assign H[3] = (N[15] & sel[3]) | (N[11] & sel[2]) | (N[7] & sel[1]) | (N[3] & sel[0]);
    
    
    
endmodule
