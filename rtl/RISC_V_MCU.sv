module RISC_V_MCU(
    input logic clk,
    input logic reset_in,
    input logic rx,    // Replace with DE10 Pin names
    output logic tx    // ^
);

    logic reset;

    // Button on DE10 lite is default high unpressed
    // Change according to needs
    assign reset = ~reset_in;

    // Optional: Instantiate MMCM Clock Generator IP

    // Bus Wires
    logic [31:0] bus_rd_data, bus_wr_data, bus_addr;
    logic bus_cs, bus_wr, bus_rd;

    KLP32V2 PROCESSOR(
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
    io_top IO_SUBSYSTEM (
        .clk         (clk),
        .reset       (reset),
        // Bus interface
        .bus_cs      (bus_cs),
        .bus_wr      (bus_wr),
        .bus_rd      (bus_rd),
        .bus_addr    (bus_addr),
        .bus_wr_data (bus_wr_data),
        .bus_rd_data (bus_rd_data),
        // UART interface
        .rx          (rx),
        .tx          (tx)
    );


endmodule
