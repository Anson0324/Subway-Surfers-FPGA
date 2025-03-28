`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 11:23:52 AM
// Design Name: 
// Module Name: top_SM
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


module top_SM(
    input C, crash, clk,
    input two, six,
    
//    output [14:0] top_TC,//keep?
    output reset,
    
    output chill_out, openL_out, openLR_out, openLMR_out, gameover_out
    );
    
    wire [4:0] PS, NS;
    
    wire chill, openL, openLR, openLMR, gameover;
    wire Next_chill, Next_openL, Next_openLR, Next_openLMR, Next_gameover;
    
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[0]), .Q(PS[0]));
    FDRE #(.INIT(1'b0)) Q6_FF[4:1] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(NS[4:1]), .Q(PS[4:1]));
    
    // Current state assignments
    assign chill = PS[0];
    assign openL = PS[1];
    assign openLR = PS[2];
    assign openLMR = PS[3];
    assign gameover = PS[4];
    
    // Next state assignments
    assign NS[0] = Next_chill;
    assign NS[1] = Next_openL;
    assign NS[2] = Next_openLR;
    assign NS[3] = Next_openLMR;
    assign NS[4] = Next_gameover;
    
    assign Next_chill = (~C & chill);
    
    assign Next_openL = (C & chill) | (~two & ~crash & openL);
    
    assign Next_openLR = (two & ~crash & openL) | (~six & ~crash & openLR);
     
    assign Next_openLMR = (six & ~crash & openLR) | (~crash & openLMR);
     
    assign Next_gameover = (~two & crash & openL) | 
                            (two & crash & openL) | 
                            (~six & crash & openLR) | 
                            (six & crash & openLR) |
                            (crash & openLMR)|
                            (gameover)
                            ;
     // Output assignments
    assign chill_out = chill;
    assign openL_out = openL;
    assign openLR_out = openLR;
    assign openLMR_out = openLMR;
    assign gameover_out = gameover;
    
    assign reset = (C & chill) | (two & ~crash & openL);

     

    
endmodule
