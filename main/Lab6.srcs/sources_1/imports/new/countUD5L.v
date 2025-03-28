`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2024 01:46:02 PM
// Design Name: 
// Module Name: countUD5L
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


module countUD5L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [4:0] Din,
    
    output [4:0] Q,
    output UTC,
    output DTC
    );
    
    //increment
    wire inc;
    wire [4:0] i;
    assign  inc = CE & UD;
    
    assign i[0] = Q[0] ^ (inc);
    assign i[1] = Q[1] ^ (inc & Q[0]);
    assign i[2] = Q[2] ^ (inc & Q[0] & Q[1]);
    assign i[3] = Q[3] ^ (inc & Q[0] & Q[1] & Q[2]);
    assign i[4] = Q[4] ^ (inc & Q[0] & Q[1] & Q[2] & Q[3]);
    
    //decrement
    wire dec;
    wire [4:0] d;
    assign dec = CE & ~UD;
    
    assign d[0] = Q[0] ^ (dec);
    assign d[1] = Q[1] ^ (dec & ~Q[0]);
    assign d[2] = Q[2] ^ (dec & ~Q[0] & ~Q[1]);
    assign d[3] = Q[3] ^ (dec & ~Q[0] & ~Q[1] & ~Q[2]);
    assign d[4] = Q[4] ^ (dec & ~Q[0] & ~Q[1] & ~Q[2] & ~Q[3]);
    
    //select ouotput
    wire [4:0] mux1_out;
    wire [4:0] D;
    mux mux_a (.i0(i[0]), .i1(d[0]), .s(~UD), .out(mux1_out[0]));
    mux mux_b (.i0(mux1_out[0]), .i1(Din[0]), .s(LD), .out(D[0]));
    
    mux mux_c (.i0(i[1]), .i1(d[1]), .s(~UD), .out(mux1_out[1]));
    mux mux_d (.i0(mux1_out[1]), .i1(Din[1]), .s(LD), .out(D[1]));
    
    mux mux_e (.i0(i[2]), .i1(d[2]), .s(~UD), .out(mux1_out[2]));
    mux mux_f (.i0(mux1_out[2]), .i1(Din[2]), .s(LD), .out(D[2]));
    
    mux mux_g (.i0(i[3]), .i1(d[3]), .s(~UD), .out(mux1_out[3]));
    mux mux_h (.i0(mux1_out[3]), .i1(Din[3]), .s(LD), .out(D[3]));
    
    mux mux_i (.i0(i[4]), .i1(d[4]), .s(~UD), .out(mux1_out[4]));
    mux mux_j (.i0(mux1_out[4]), .i1(Din[4]), .s(LD), .out(D[4]));
    
    //DFF
    wire clock_enable = CE | LD;
    FDRE #(.INIT(1'b0)) FF0 (.C(clk), .R(1'b0), .CE(clock_enable), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .R(1'b0), .CE(clock_enable), .D(D[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0)) FF2 (.C(clk), .R(1'b0), .CE(clock_enable), .D(D[2]), .Q(Q[2]));
    FDRE #(.INIT(1'b0)) FF3 (.C(clk), .R(1'b0), .CE(clock_enable), .D(D[3]), .Q(Q[3]));
    FDRE #(.INIT(1'b0)) FF4 (.C(clk), .R(1'b0), .CE(clock_enable), .D(D[4]), .Q(Q[4]));
    
    assign UTC = &Q;
    assign DTC = &(~Q);
    
endmodule
