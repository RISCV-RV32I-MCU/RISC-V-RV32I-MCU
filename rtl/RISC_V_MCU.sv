module RISC_V_MCU(
    input logic clk,
    input logic reset_in
);

    logic reset;

    // Button on DE10 lite is default high unpressed
    // Change according to needs
    assign reset = ~reset_in;

    // Instantiate MMCM Clock Generator

    // Bus Wires
    logic [31:0] bus_rd_data, bus_wr_data, bus_addr;
    logic bus_cs, bus_wr, bus_rd;

    KLP32V2 processor(
        .clk(clk),
        .reset(reset),

        // MMIO Bus
        .bus_addr(bus_addr),
        .bus_wr_data(bus_wr_data),
        .bus_rd_data(bus_rd_data),
        .bus_cs(bus_cs),
        .bus_wr(bus_wr),
        .bus_rd(bus_rd)
    );

    // TODO
    // //Instantiate Peripheral Module
    // io_top io_unit
    // (

    // );

endmodule
