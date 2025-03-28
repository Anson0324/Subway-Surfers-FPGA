`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2024 06:07:55 PM
// Design Name: 
// Module Name: test_top
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


module test_top();
// Inputs
   reg btnC,btnD,btnU,btnL,btnR;
   reg [15:0] sw;
   reg clkin;
   reg greset;  //use as input to whatever will be connected to the global reset pin

// Output
   wire [3:0] an;
   wire dp;
   wire [6:0] seg;
   wire [15:0] led;
   wire Hsync;
   wire [3:0] vgaBlue;
   wire [3:0] vgaGreen;
   wire [3:0] vgaRed;
   wire Vsync;
   wire oops;
   wire rgb_oops;


// You may need to replace the instantiation below
// to match your top level module and its port names.

// Instantiate the UUT
   top UUT (
              .btnU(btnU),  
              .btnD(greset), //btnD is the global reset in W24 Lab6
              .btnC(btnC),  
              .btnR(btnR), 
              .btnL(btnL),  
              .clkin(clkin), 
              .seg(seg), 
              .dp(dp), 
              .an(an),
              .vgaBlue(vgaBlue),
              .vgaRed(vgaRed),
              .vgaGreen(vgaGreen),        
              .Vsync(Vsync), 
              .Hsync(Hsync), 
              .sw(sw), 
              .led(led)
   );
   // Clock parameters
   parameter PERIOD = 10;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET = 2;

       initial
       begin
              clkin = 1'b0;
          #OFFSET
              clkin = 1'b1;
      forever
         begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
         end
       end
   
   
   initial 
     begin 
       sw = 16'b0;
       btnU = 1'b0;
       btnC = 1'b0;
       btnD = 1'b0;
       btnL = 1'b0;
       btnR = 1'b0;
       greset = 1'b0;
       #600 greset = 1'b1;
       #80 greset = 1'b0;
       
       
       #10000 btnU = 1;
     
     
     
     
     
     
     end
       
    
endmodule
