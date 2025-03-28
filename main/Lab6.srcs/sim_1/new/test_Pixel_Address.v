`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Martine
// 
// Create Date: 9/27/2022 09:26:52 PM
// Design Name: 
// Module Name: test_add
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


module test_Pixel_Address( ); // no inputs/outputs, this is a wrapper


    reg clk;
    
    wire [14:0] v_out;
    wire [14:0] h_out;
    
// create one instance of your top level
// and attach it to the registers and wires created above
    Pixel_Address UUT (
    .clk(clk),
    .v_out(v_out),
    .h_out(h_out)
    );
    
    
// create an oscillating signal to impersonate the clock provided on the BASYS 3 board
    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
		  clk = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = ~clk;
        end
    end

endmodule
