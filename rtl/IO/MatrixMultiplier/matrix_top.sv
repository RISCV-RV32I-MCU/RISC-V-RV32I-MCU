//--------------------------------------------------
// Matrix Top-Level Wrapper
//--------------------------------------------------
// This module wraps the `matrix` accelerator core and
// exposes only a simple CS/READ/WRITE register interface.
// No direct DMA or other external ports in this module.
module matrix_top 
(
    input  logic        clk,      // Main clock
    input  logic        reset,    // Active-high reset

    // Slot interface 
    input  logic        cs,       // Chip select
    input  logic        read,     // Read enable
    input  logic        write,    // Write enable
    input  logic [4:0]  addr,     // Register address
    input  logic [31:0] wr_data,  // Write data
    output logic [31:0] rd_data   // Read data
);

    //--------------------------------------------------
    // Internal Wishbone Signals
    //--------------------------------------------------
    logic [31:0] wb_adr_i;
    logic [31:0] wb_dat_i;
    logic        wb_we_i;
    logic        wb_stb_i;
    logic [31:0] wb_dat_o;
    logic        wb_ack_o;

    //--------------------------------------------------
    // Register Map (word-addressed)
    //   addr = 0 → CTRL register (start bit)
    //   addr = 1 → Matrix A base address
    //   addr = 2 → Matrix B base address
    //   addr = 3 → Matrix C base address
    //   addr = 4 → Matrix rows (M)
    //   addr = 5 → Matrix A cols (N)
    //   addr = 6 → Matrix cols (P)
    //   addr = 7 → STATUS register (busy/done flags)
    //--------------------------------------------------

    // Strobe & write-enable to core
    assign wb_stb_i = cs && (read || write);
    assign wb_we_i  = write && cs;

    // Build byte-address for core (word-aligned: addr * 4)
    assign wb_adr_i = { addr, 2'b00 };

    // Pass through write data
    assign wb_dat_i = wr_data;

    // Return read data from core
    assign rd_data  = wb_dat_o;

    //--------------------------------------------------
    // Core Instantiation
    //--------------------------------------------------
    // Note: DMA interface is left unconnected here—this
    // wrapper only exposes the register interface.
    matrix matrix_inst (
        .clk        (clk),
        .reset      (reset),

        // Wishbone Bus Interface
        .wb_adr_i   (wb_adr_i),
        .wb_dat_i   (wb_dat_i),
        .wb_dat_o   (wb_dat_o),
        .wb_we_i    (wb_we_i),
        .wb_stb_i   (wb_stb_i),
        .wb_ack_o   (wb_ack_o),

        // DMA Interface (hidden/tied off)
        .dma_req    (),
        .dma_ack    (1'b0),
        .dma_addr   (),
        .dma_data_i (32'd0),
        .dma_data_o (),
        .dma_we     ()
    );

endmodule
