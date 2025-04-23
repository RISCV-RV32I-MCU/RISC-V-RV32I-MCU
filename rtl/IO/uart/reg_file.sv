`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2024 01:05:33 AM
// Design Name: 
// Module Name: reg_file
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

//many registers put together to form a RAM
// 1 Asynch read, 1 Synch write port
module reg_file
  #(parameter ADDR_WIDTH = 2, DATA_WIDTH = 8)
    (
        input logic clk,
        input logic wr_en,//write enable
        input logic [ADDR_WIDTH - 1: 0] r_addr, // read address
        input logic [ADDR_WIDTH - 1: 0] w_addr, // write address
        input logic [DATA_WIDTH - 1: 0] w_data,
        output logic [DATA_WIDTH - 1: 0] r_data
    );
    
    //Signal declaration
    logic [DATA_WIDTH - 1: 0] memory [0: 2 ** ADDR_WIDTH - 1];
    
    //Write
    always_ff @(posedge clk)
    begin
        if (wr_en)
            memory[w_addr] <= w_data;
    end
            
    //Read
    assign r_data = memory[r_addr];
endmodule