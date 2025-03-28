`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2024 07:22:26 PM
// Design Name: 
// Module Name: RingCounter
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


module RingCounter(
    input digsel,
    input clk,
    
    output [3:0] out
    );
//    wire ce = clk & digsel;
    wire [3:0] Q;
    //if dig_sel == 1 && clk == 1, then shift
//    assign Q[0] = ~Q[0];
    FDRE #(.INIT(1'b1)) FF0 (.C(clk), .R(1'b0), .CE(digsel), .D(Q[3]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .R(1'b0), .CE(digsel), .D(Q[0]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) FF2 (.C(clk), .R(1'b0), .CE(digsel), .D(Q[1]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) FF3 (.C(clk), .R(1'b0), .CE(digsel), .D(Q[2]), .Q(Q[3])); 
    
    assign out = Q;
endmodule
