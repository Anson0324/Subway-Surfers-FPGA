`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 04:51:55 AM
// Design Name: 
// Module Name: slugSM
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


module slugSM(
        input C, L, R, clk,
        input [14:0] move_left, move_right,
        
        output out_mid,
               out_mid_left, out_left, out_left_mid,
               out_mid_right, out_right, out_right_mid

    );
    
    wire [7:0] PS, NS;
    
    wire mid, 
         mid_left, left, left_mid,
         mid_right, right, right_mid,
         standby;
         
    wire Next_mid,
         Next_mid_left, Next_left, Next_left_mid,
         Next_mid_right, Next_right, Next_right_mid,
         Next_standby;

    
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[0]), .Q(PS[0]));
    FDRE #(.INIT(1'b0)) Q7_FF[7:1] (.C({7{clk}}), .R(7'b0), .CE(7'b1111111), .D(NS[7:1]), .Q(PS[7:1]));
    
    assign standby = PS[0];
    assign mid = PS[1];
    assign mid_left = PS[2];
    assign left = PS[3];
    assign left_mid = PS[4];
    assign mid_right = PS[5];
    assign right = PS[6];
    assign right_mid = PS[7];
    
    assign NS[0] = Next_standby;
    assign NS[1] = Next_mid;
    assign NS[2] = Next_mid_left;
    assign NS[3] = Next_left;
    assign NS[4] = Next_left_mid;
    assign NS[5] = Next_mid_right;
    assign NS[6] = Next_right;
    assign NS[7] = Next_right_mid;
    
    assign Next_standby = (~C & standby);
    
    assign Next_mid = 
                        (move_right==15'd70 & left_mid) | 
                        (move_left==15'd70 & right_mid) |
                        
                        (L & R & mid)|
                        (~L & ~R & mid)|
                        (C & standby)
                      
    ;
                      
    
    
    
    assign Next_mid_left =
                        (move_left<15'd70 & mid_left) |
                        (L & ~R & mid)
                        ;
    
    assign Next_left = 
                        (move_left==15'd70 & mid_left) |
                        (~R & left)
                        ;
                       
    assign Next_left_mid = 
                        (R & left) | 
                        (move_right<15'd70 & left_mid)
                        ;
    
    
    
    assign Next_mid_right = 
                        (move_right<15'd70 & mid_right) |
                        (~L & R & mid)
                        ;
                            
    assign Next_right = 
                        (move_right==15'd70 & mid_right) | 
                        (~L & right)
                        ;
                        
    assign Next_right_mid = 
                        (L & right) | 
                        (move_left<15'd70 & right_mid)
                        ;

    
    assign out_mid = mid;
    assign out_mid_left = mid_left;
    assign out_left = left;
    assign out_left_mid = left_mid;
    assign out_mid_right = mid_right;
    assign out_right = right;
    assign out_right_mid = right_mid;
    
//    assign reset = (~U & L & ~R & mid) | (R & left)
//                    | (~U & ~L & R & mid) | (L & right);
                 


endmodule
