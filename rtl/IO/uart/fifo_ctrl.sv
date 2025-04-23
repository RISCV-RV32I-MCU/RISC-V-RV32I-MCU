`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2024 01:58:36 AM
// Design Name: 
// Module Name: fifo_ctrl
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

//doesn't deal with the data itself, just the flow of the data
//basically a FSM

module fifo_ctrl
#(parameter ADDR_WIDTH = 4)
(
    input logic clk, reset,
    input logic wr, rd, //write and read commands
    output logic empty, full, // empty and full flags
    output logic [ADDR_WIDTH - 1: 0] w_addr,//write address (pointer)
    output logic [ADDR_WIDTH - 1: 0] r_addr//read address (POINTER), is the same number of bits wide, as there are addresses
);

//define the pointers as registers

logic [ADDR_WIDTH-1:0] w_ptr_logic, w_ptr_next, w_ptr_succ;//write pointer, as a register, current and next state
logic [ADDR_WIDTH-1:0] r_ptr_logic, r_ptr_next, r_ptr_succ;//read pointer, as a register 

//Internal signals, to avoid dealing with the (external) full/empty flags directly
logic full_logic, empty_logic, full_next, empty_next;

//State Register Logic

always_ff @( posedge clk, posedge reset ) 
begin
    if (reset)
        begin
            w_ptr_logic <= 0;
            r_ptr_logic <= 0;
            full_logic <= 1'b0;
            empty_logic <= 1'b1; //will initially be empty
        end   
    else
        begin
            w_ptr_logic <= w_ptr_next;
            r_ptr_logic <= r_ptr_next;
            full_logic <= full_next;
            empty_logic <= empty_next;
        end
end

//Next State Logic

always_comb 
begin
    // successive pointer values
      w_ptr_succ = w_ptr_logic + 1;
      r_ptr_succ = r_ptr_logic + 1;
      // default: keep old values
      w_ptr_next = w_ptr_logic;
      r_ptr_next = r_ptr_logic;
      full_next = full_logic;
      empty_next = empty_logic;

    unique case ({wr, rd})//the wr and rd signals control the behaviour of the controller

        2'b01: //read
            begin
                if (~empty_logic)
                begin
                    r_ptr_next = r_ptr_succ;
                    full_next = 1'b0; //since the location, the rd pointer is at, was read from, it's no longer a full fifo
                    if (r_ptr_succ == w_ptr_logic)// if the read pointer location is the same as the write pointer (aka it read the last value)
                        empty_next = 1'b1;//then the fifo is empty
                end
            end

        2'b10: //write
            begin
                if (~full_logic)//fifo not full
                begin
                    w_ptr_next = w_ptr_succ;
                    empty_next = 1'b0; //since the location, the wr pointer is at, was written to, it's no longer an empty fifo
                     if (w_ptr_succ == r_ptr_logic)// if the write pointer location is the same as the read pointer (aka it wrote the last available value)
                        full_next = 1'b1;//then the fifo is full
                end
            end

        2'b11: //read and write simultaneously --- possible, since it's a dual port ram
            begin
               w_ptr_next = w_ptr_succ;
               r_ptr_next = r_ptr_succ;
            end
        default: ;//2'b00 case is included here (neither read nor write)
    endcase
end

//Output Logic

   assign w_addr = w_ptr_logic;
   assign r_addr = r_ptr_logic;
   assign full = full_logic;
   assign empty = empty_logic;

endmodule
