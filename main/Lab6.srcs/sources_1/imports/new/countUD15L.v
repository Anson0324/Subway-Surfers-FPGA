`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2024 01:19:39 PM
// Design Name: 
// Module Name: countUD15L
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


module countUD15L(
    input [15:1] sw,
    input CE,
    input UD,
    input LD,
    input clk,
    
    output [14:0] Q,
    output UTC,
    output DTC
    );
    
    wire [2:0] up;
    wire [2:0] down;
    wire [1:0] result;
    assign result[0] = (CE & up[0] & UD) | (CE & down[0] & ~UD);
    assign result[1] = (CE & up[1] &up[0] & UD) | (CE & down[1] & down[0] & ~UD);
//    assign result[2] = (CE & carry[4] & UD) | (CE & carry[5] & ~UD);
//    assign result[2] = carry[2] | carry[3];
    
    countUD5L counter0 (.clk(clk), .UD(UD), .CE(CE), .LD(LD), .Din(sw[5:1]), .Q(Q[4:0]), .UTC(up[0]), .DTC(down[0]));
    countUD5L counter1 (.clk(clk), .UD(UD), .CE(result[0]), .LD(LD), .Din(sw[10:6]), .Q(Q[9:5]), .UTC(up[1]), .DTC(down[1]));
    countUD5L counter2 (.clk(clk), .UD(UD), .CE(result[1]), .LD(LD), .Din(sw[15:11]), .Q(Q[14:10]), .UTC(up[2]), .DTC(down[2]));
    assign UTC = &up;
    assign DTC = &down;
    
endmodule
