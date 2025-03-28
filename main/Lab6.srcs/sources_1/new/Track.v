`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2024 08:05:55 PM
// Design Name: 
// Module Name: Track
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


module Track(
    input open, clk, frame,
    input [14:0] what_bot,
    
    output train1_test, train2_test,
    output [14:0] top1, bot1, top2, bot2
    
    );
    
    wire [14:0] init1_out, init2_out, train1_out, train2_out;
    wire [14:0] stop_init1, stop_init2;
    wire [5:0] len1, len2; //everything works after chaning to 5 bit
    wire [6:0] delay1, delay2;
    wire [14:0] TC1, TC2;//gotta make more than 128
    
    wire train1_offscreen = (top1 > 15'd479 & bot1 > 15'd479);
    wire train2_offscreen = (top2 > 15'd479 & bot2 > 15'd479); //additional conditional is to not get same len
    
    wire somewhere_onscreen1 = (15'd156 < bot1) & (bot1 < 15'd207);
    wire somewhere_onscreen2 = (15'd185 < bot2) & (bot2 < 15'd222);
    
    //test_out==========================================
    assign train1_test = bot1 == train1_offscreen;
    assign train2_test = bot2 == train2_offscreen;
    
    assign stop_init1 = (15'd60 + len1);
    assign stop_init2 = (15'd60 + len2);
    
    
    Ran_Num_Gen length_size1 (.run(train1_offscreen | ~open) ,.clk(clk), .rnd(len1)); //run it only when train is in screen
    Ran_Num_Gen length_size2 (.run(train2_offscreen | ~open | (top2 == 15'd0 & bot2 == 15'd0)),//otherwise two trains have same length
                                 .clk(clk), .rnd(len2)); //run it only when train is in screen
    
    
    Ran_Num_Gen delay_time1 (.run(open & somewhere_onscreen1) ,.clk(clk), .rnd(delay1)); //run it only when train is in screen
    Ran_Num_Gen delay_time2 (.run(open & somewhere_onscreen2) ,.clk(clk), .rnd(delay2)); //run it only when train is in screen
                
    //TC---------------------------------
    countUD15L TC_train1 (
    //input
      .sw(15'b0),
      .CE(frame),
      .UD(1'b1),
      .LD(bot2 == what_bot),
      .clk(clk),
    //output
      .Q(TC1)//more than 7bit
    );
    
    countUD15L TC_train2 (
    //input
      .sw(15'b0),
      .CE(frame),
      .UD(1'b1),
      .LD(bot1 == what_bot),
      .clk(clk),
    //output
      .Q(TC2)//more than 7bit
    );
    //------------------------------------
    
    countUD15L init1 (
    //input
      .sw(15'b0),
      .CE(frame & open & (init1_out < stop_init1) & (delay1 < TC1)), //only count up to 60+len1
      .UD(1'b1),
      .LD(bot2 == what_bot), //bot2 400
      .clk(clk),
    //output
      .Q(init1_out)
    );
    
    //train1 counter
    countUD15L train1 (
        //input
        .sw(15'b0),
        
        .CE(
            (init1_out == stop_init1) & //only count after init finishes
            frame &
            open
         ),
        .UD(1'b1),
        .LD(bot2 == what_bot), //bot2 400
        .clk(clk),
        //output
        .Q(train1_out)
    );
    
    assign top1 = train1_out;
    assign bot1 = train1_out + init1_out;
//-----------------------------------------------------------------------------------------------------------
    countUD15L init2 (
    //input
      .sw(15'b0),
      .CE(frame & open & init2_out < stop_init2 & (bot1 > what_bot) & (delay2 < TC2)), //cant start with train1
      .UD(1'b1),
      .LD(bot1 == what_bot),
      .clk(clk),
    //output
      .Q(init2_out)
    );
    
    //train1 counter
    countUD15L train2 (
        //input
        .sw(15'b0),
        
        .CE(
            (init2_out == stop_init2) & //only counter after init
            frame &
            open
         ),
        .UD(1'b1),
        .LD(bot1 == what_bot),
        .clk(clk),
        //output
        .Q(train2_out)
    );
    
    assign top2 = train2_out;
    assign bot2 = train2_out + init2_out;
    
endmodule
