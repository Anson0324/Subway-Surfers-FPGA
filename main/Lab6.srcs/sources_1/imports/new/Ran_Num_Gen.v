`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 12:19:42 PM
// Design Name: 
// Module Name: Ran_Num_Gen
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


module Ran_Num_Gen(
    input run,
    input clk,
    
    output [7:0] rnd
    );
    
    wire Din = rnd[0] ^ rnd[5] ^ rnd[6] ^ rnd[7];
    
    FDRE #(.INIT(1'b1) ) FF0 (.C(clk), .R(1'b0), .CE(run), .D(Din), .Q(rnd[0]));
    FDRE FF7_1[6:0] (.C({7{clk}}), .R(7'b0), .CE({7{run}}), .D(rnd[6:0]), .Q(rnd[7:1]));
endmodule
