`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 11:16:11 AM
// Design Name: 
// Module Name: top
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


module top(
    // Inputs
    input btnC, btnD, btnU, btnL, btnR,
    input [15:0] sw,
    input clkin,
    input greset,  // use as input to whatever will be connected to the global reset pin
    
    // Outputs
    output [3:0] an,
    output dp,
    output [6:0] seg,
    output [15:0] led,
    output Hsync,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output [3:0] vgaRed,
//    output oops,
//    output rgb_oops,
    output Vsync
    );
    
    
    wire clk, digsel;
    
    //H V
    wire [14:0] H, V;
    wire AR = (15'd0 <= H) & (H <= 15'd639) & (15'd0 <= V) & (V <= 15'd479);
    
    wire frame = (H == 15'd799) & (V == 15'd524);
    wire h_frame = ((H == 15'd799) & (V == 15'd524)) | ((H == 15'd799) & (V == 15'd262));
    wire t_frame = ((H == 15'd799) & (V == 15'd524)) | ((H == 15'd799) & (V == 15'd262)) | ((H == 15'd799) & (V == 15'd0));
    
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnD), .clk(clk), .digsel(digsel));
    
    wire Hout, Vout;
    wire [3:0] rout, gout, bout;
    
    //syn btns
    wire btnC_out, btnU_out, btnL_out, btnR_out;
    FDRE #(.INIT(1'b0)) syn0 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(btnC_out));
    FDRE #(.INIT(1'b0)) syn1 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnU), .Q(btnU_out));
    FDRE #(.INIT(1'b0)) syn2 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnL), .Q(btnL_out));
    FDRE #(.INIT(1'b0)) syn3 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnR), .Q(btnR_out));
    
    
    //FF
    FDRE #(.INIT(1'b1)) hsync_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(Hout), .Q(Hsync));
    FDRE #(.INIT(1'b1)) vsync_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(Vout), .Q(Vsync));
    
    FDRE #(.INIT(1'b1)) r_FF[3:0] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(rout), .Q(vgaRed));
    FDRE #(.INIT(1'b1)) g_FF[3:0] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(gout), .Q(vgaGreen));
    FDRE #(.INIT(1'b1)) b_FF[3:0] (.C({4{clk}}), .R(4'b0), .CE(4'b1111), .D(bout), .Q(vgaBlue));
    
    //slug SM io
    wire out_mid, 
       out_mid_left, out_left, out_left_mid,
       out_mid_right, out_right, out_right_mid;
    
    //Top State Machine io
    wire crash, two, six, reset;
    wire chill_out, openL_out, openLR_out, openLMR_out, gameover_out;
    
    wire [14:0] bar_out;
    wire [14:0] flash_out, top_TC;
    wire has_energy = bar_out <= 15'd193;
    wire hovering = btnU_out & out_mid & has_energy & ~chill_out & ~gameover_out;
    
    
    wire [14:0] move_left;
    wire [14:0] move_right;
    
    Pixel_Address Pixel_A (
        .clk(clk),
        .v_out(V),
        .h_out(H)
    );
    
    Syncs Sy (
        .clk(clk),
        .Hsync(Hout),
        .Vsync(Vout)
    );
    
    //border
    wire b_top = (15'd0 <= H) & (H <= 15'd639) & (15'd0 <= V) & (V <= 15'd8);
    wire b_bottom = (15'd0 <= H) & (H <= 15'd639) & (15'd471 <= V) & (V <= 15'd479);
    wire b_left = (15'd0 <= H) & (H <= 15'd8) & (15'd0 <= V) & (V <= 15'd479);
    wire b_right = (15'd631 <= H) & (H <= 15'd639) & (15'd0 <= V) & (V <= 15'd479);
    wire border = b_top | b_bottom | b_left | b_right;
    
    //power bar
    countUD15L bar_counter (
    //input
      .sw(15'b0),
      .CE( frame & ((hovering & bar_out <= 15'd193) | (~hovering & bar_out > 15'd0))),// doesnt matter if i press U or not
      .UD(hovering),
      .LD(1'b0),
      .clk(clk),
    //output
      .Q(bar_out)
    );
    
    wire power_bar = (15'd20 <= H) & (H <= 15'd40) & ((15'd40 + bar_out) <= V) & (V <= (15'd232));
    
    //slug movin'
    countUD15L flashing (
    //input
      .sw(15'b0),
      .CE(frame),
      .UD(1'b1),
      .LD(flash_out == 15'd64),
      .clk(clk),
    //output
      .Q(flash_out)
    );
    
    //slug SM
       
    slugSM slug_State_Machine (
        .move_left(move_left),
        .move_right(move_right),
        
        .C(btnC_out),
        .L(btnL_out & ~hovering), //Pressing btnL or btnR during a transition or while the slug is hovering has no effect.
        .R(btnR_out & ~hovering),          
        
        
        .clk(clk),      
        
        .out_mid(out_mid),      
          
        .out_mid_left(out_mid_left),
        .out_left(out_left),
        .out_left_mid(out_left_mid),
        
        .out_mid_right(out_mid_right),
        .out_right(out_right),
        .out_right_mid(out_right_mid)
        
//        .reset(reset)
    );
    
    //slug moving display
    countUD15L move_left_counter (
    //input
      .sw(15'b0),
      .CE((out_mid_left | out_right_mid) & h_frame & ~gameover_out),//cannot move in gameover
      .UD(1'b1),
      .LD(out_mid),
      .clk(clk),
    //output
      .Q(move_left),
      .UTC(),
      .DTC()
    );
    
    countUD15L move_right_counter (
    //input
      .sw(15'b0),
      .CE((out_mid_right | out_left_mid) & h_frame & ~gameover_out),//cannot move in gameover
      .UD(1'b1),
      .LD(out_mid),
      .clk(clk),
    //output
      .Q(move_right),
      .UTC(),
      .DTC()
    );
    
    //train
    wire [14:0] top1L, bot1L, top2L, bot2L,
                top1M, bot1M, top2M, bot2M,
                top1R, bot1R, top2R, bot2R;
                
    wire train1_test, train2_test;
    
    
    Track trackL (
        .open(openL_out | openLR_out | openLMR_out), //chnage later
        .clk(clk),
        .frame(frame),
        .what_bot(15'd400),
        
        .top1(top1L),
        .top2(top2L),
        .bot1(bot1L),
        .bot2(bot2L)
        
        
    );
    Track trackM (
        .open(openLMR_out), //chnage later
        .clk(clk),
        .frame(frame),
        .what_bot(15'd440),
        
        .top1(top1M),
        .top2(top2M),
        .bot1(bot1M),
        .bot2(bot2M)
        

    );
    Track trackR (
        .open(openLR_out | openLMR_out), //chnage later
        .clk(clk),
        .frame(frame),
        .what_bot(15'd400),
        
        .top1(top1R),
        .top2(top2R),
        .bot1(bot1R),
        .bot2(bot2R)
       
    );
    
    
    //Top State Machine--------------------
    //resetTimer
    countUD15L top_reset_timer (
    //input
      .sw(15'b0),
      .CE(frame),
      .UD(1'b1),
      .LD(reset),
      .clk(clk),
    //output
      .Q(top_TC)
    );
    
    assign two = top_TC == 15'd128;
    assign six = top_TC == 15'd384;
    
    //SM
    top_SM TSM(
        // Inputs
        .clk(clk),
        .C(btnC_out),
        .crash(crash),
        .two(two),
        .six(six),
        
        // Outputs
        .reset(reset),
        .chill_out(chill_out),    
        .openL_out(openL_out),
        .openLR_out(openLR_out),
        .openLMR_out(openLMR_out),
        .gameover_out(gameover_out)
    );
    

    
    //--------------------------------------
    
    //slug
//    wire slug = (15'd305 -move_left +move_right <= H) & (H <= 15'd321 -move_left +move_right) & (15'd360 <= V) & (V <= 15'd376);
    wire slug = (15'd305  +move_right <= H +move_left) & (H +move_left <= 15'd321  +move_right) & (15'd360 <= V) & (V <= 15'd376);
    
    //led test
//    assign led[7] = out_mid;
    
//    assign led[6] = out_mid_right;
//    assign led[5] = out_right_mid;
//    assign led[4] = out_right;
    
//    assign led[8] = out_mid_left;
//    assign led[9] = out_left_mid;
//    assign led[10] = out_left;
    
//    assign led[0] = hovering;
//    assign led[14] = train1_test;
//    assign led[15] = train2_test;
    
    assign led[0] = chill_out;
    assign led[1] = openL_out;
    assign led[2] = openLR_out;
    assign led[3] = openLMR_out;
    assign led[4] = gameover_out;

    assign led[9] = out_mid;

    assign led[8] = out_mid_right | out_right_mid;
    assign led[7] = out_right;

    assign led[10] = out_mid_left | out_left_mid;
    assign led[11] = out_left;
    
    //center lines
    wire c1 = (H == 15'd243) & (15'd0 <= V) & (V <= 15'd479);
    wire c2 = (H == 15'd313) & (15'd0 <= V) & (V <= 15'd479);
    wire c3 = (H == 15'd383) & (15'd0 <= V) & (V <= 15'd479);
    
    wire c4 = (15'd0 <= H) & (H <= 15'd243) & (15'd400 == V);
    wire c5 = (15'd243 <= H) & (H <= 15'd313) & (15'd440 == V);
    wire c6 = (15'd313 <= H) & (H <= 15'd383) & (15'd440 == V);
    wire c7 = (15'd383 <= H) & (H <= 15'd639) & (15'd400 == V);
    wire c = c1 | c2 | c3 | c4 | c5 | c6 | c7;
    
    //color output
    wire flash = (flash_out[4]);
    
    //trains figures
    wire train1L = (15'd213 <= H) & (H <= 15'd273) & (top1L <= V) & (V <= bot1L);
    wire train2L = (15'd213 <= H) & (H <= 15'd273) & (top2L <= V) & (V <= bot2L);
    
    wire train1M = (15'd283 <= H) & (H <= 15'd343) & (top1M <= V) & (V <= bot1M);
    wire train2M = (15'd283 <= H) & (H <= 15'd343) & (top2M <= V) & (V <= bot2M);
    
    wire train1R = (15'd353 <= H) & (H <= 15'd413) & (top1R <= V) & (V <= bot1R);
    wire train2R = (15'd353 <= H) & (H <= 15'd413) & (top2R <= V) & (V <= bot2R);
    
    wire train_first = train1L | train1M | train1R;
    wire train_second = train2L | train2M | train2R;
    wire train_all = train1L | train2L | train1M | train2M | train1R | train2R;
    
    wire solid = ({4{~gameover_out}} & ({4{~hovering}} | {4{bar_out >= 15'd193}}));
    wire hover_flash = {4{flash}} & ({4{hovering}} & {4{bar_out <= 15'd192}});
    wire gg_flash = {4{flash}} & ({4{gameover_out}});
    
    
    
    assign bout = {4{AR}} &
                     ({4{border}} & 4'd15) |
                     ({4{c}} & 4'd15 & {4{sw[15]}})| //center lines

                    ({4{slug}} & 4'd0 & {4{solid}})| //solid
                    ({4{slug}} & 4'd15 & {4{hover_flash}})| //hover flash
                    ({4{slug}} & 4'd0 & {4{gg_flash}})| //gg flash
                     
                     ({4{train_first}} & 4'd15 & {4{sw[15]}})| //train1
                     ({4{train_all}} & 4'd15 & {4{~sw[15]}})
                     
                     
                     ;
                     
                     
    assign gout = {4{AR}} &
                      ({4{border}} & 4'd15) |
                      ({4{power_bar}} & 4'd15) | //power bar
                      
                      
                    ({4{slug}} & 4'd15 & {4{solid}})| //solid
                    ({4{slug}} & 4'd0 & {4{hover_flash}})| //hover flash
                    ({4{slug}} & 4'd15 & {4{gg_flash}})| //gg flash
                      
                      
                      ({4{c}} & 4'd15 & {4{sw[15]}}) //center lines

                      ;
                      
                      
    assign rout = {4{AR}} &
                    ({4{border}} & 4'd15) | 
                    
                    ({4{slug}} & 4'd15 & {4{solid}})| //solid
                    ({4{slug}} & 4'd15 & {4{hover_flash}})| //hover flash
                    ({4{slug}} & 4'd15 & {4{gg_flash}})| //gg flash
                    
                    ({4{train_second}} & 4'd15 & {4{sw[15]}}) //train3
                    
                    ;

    
    assign crash = slug & train_all & ~hovering & ~sw[3];
    
    //score
    wire [14:0] score_outL , score_outM, score_outR, score_out;
    wire [4:0] RC_out, Sel_out;
    
    wire over_trainL = top1L == 15'd376 | top2L == 15'd376;
    wire over_trainM = top1M == 15'd376 | top2M == 15'd376;
    wire over_trainR = top1R == 15'd376 | top2R == 15'd376;

    countUD15L score_counterL (
    //input
      .sw(15'b0),
      .CE(over_trainL & frame & ~gameover_out),//cannot count too fast and cannot score in gameover
      .UD(1'b1),
      .LD(1'b0),
      .clk(clk),
    //output
      .Q(score_outL)
    );
    countUD15L score_counterM (
    //input
      .sw(15'b0),
      .CE(over_trainM & frame & ~gameover_out),//cannot count too fast and cannot score in gameover
      .UD(1'b1),
      .LD(1'b0),
      .clk(clk),
    //output
      .Q(score_outM)
    );
    countUD15L score_counterR (
    //input
      .sw(15'b0),
      .CE(over_trainR & frame & ~gameover_out),//cannot count too fast and cannot score in gameover
      .UD(1'b1),
      .LD(1'b0),
      .clk(clk),
    //output
      .Q(score_outR)
    );
    
//    assign led =score_out;
    assign score_out = score_outL+score_outM+score_outR;
    //same staff
    RingCounter RC (.digsel(digsel), .clk(clk), .out(RC_out));
    Selector Sel (.N(16'b0 | score_out), .sel(RC_out), .H(Sel_out)); //what is N?
    hex7seg hex (.n(Sel_out), .seg(seg));
    
    assign an[3] =  1'b1;
    assign an[2] =  1'b1;
    assign an[1] = ~RC_out[1];
    assign an[0] = ~RC_out[0];
endmodule
//problem
//unknown state when two btns pressed at the same time
//stuck in transition
//flashing too fast
//got rid of hover state
//