`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2024 04:17:31 AM
// Design Name: 
// Module Name: fifo
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


module fifo
#(parameter ADDR_WIDTH = 4, DATA_WIDTH = 8)
(
    input logic clk, reset,
    input logic [DATA_WIDTH - 1: 0] w_data,//write data
    output logic [DATA_WIDTH - 1: 0] r_data,//read data
    input logic wr, rd,
    output logic full, empty
);

//(Internal) Signal Declaration
logic [ADDR_WIDTH - 1: 0] w_addr, r_addr; //write and read address
logic wr_en, full_tmp;

// write enabled only when FIFO is not full
   assign wr_en = wr & ~full_tmp;
   assign full = full_tmp;

//Register File

reg_file #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) RegFile
(
    .* //matches the names
);

//FIFO Control Unit FSM

fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) CtrlUnit
(
    .*, .full(full_tmp)
);
endmodule
