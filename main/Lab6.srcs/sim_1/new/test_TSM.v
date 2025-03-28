`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 05:59:44 PM
// Design Name: 
// Module Name: test_TSM
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


module test_TSM();

    reg C, crash, clk;
    reg two, six;
    
    wire reset;
    
    wire chill_out, openL_out, openLR_out, openLMR_out, gameover_out;
    
    top_SM top_SM_instance (
        .C(C),
        .crash(crash),
        .clk(clk),
        .two(two),
        .six(six),
        .reset(reset),             // Assuming 'reset' is an input to top_SM
        .chill_out(chill_out),     // Assuming 'chill_out' is an output from top_SM
        .openL_out(openL_out),     // Assuming 'openL_out' is an output from top_SM
        .openLR_out(openLR_out),   // Assuming 'openLR_out' is an output from top_SM
        .openLMR_out(openLMR_out), // Assuming 'openLMR_out' is an output from top_SM
        .gameover_out(gameover_out) // Assuming 'gameover_out' is an output from top_SM
    );

// create an oscillating signal to impersonate the clock provided on the BASYS 3 board
    initial    // Clock process for clkin
    begin
	clk = 1'b1;
        #20
        forever
        begin
            #50 clk = ~clk;
        end
    end   
       
       
       initial
       begin
       C = 0;
       crash = 0;
       two= 0;
       six = 0;
       
       #5000 C = 1;
//       #500 C = 0;
       
       #5000 two = 1;
//       #500 two = 0;
       
       #5000 six = 1;
//       #500 six = 0;
       
       #5000 crash = 1;
  
       end
       
endmodule
